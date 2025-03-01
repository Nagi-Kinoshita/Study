/// matlab上かterminal上で以下のコマンドを実行する。
/// \
mex read.cpp \
-Iinclude/OpenEXR \
-Iinclude/Imath \
-Llib \
-lOpenEXRUtil-3_0 \
-lOpenEXR-3_0 \
-lIlmThread-3_0 \
-lIex-3_0 \
-lImath-3_0 \
-lz

/// OpenEXRのライブラリは静的ライブラリを意図した場所に出力するため、以下のオプションをつける。
/// cmake -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=$install_directory_path

#include <codecvt>
#include <iostream>
#include <locale>
#include <string>

#include "ImathBox.h"
#include "ImfChannelList.h"
#include "ImfFrameBuffer.h"
#include "ImfHeader.h"
#include "ImfInputFile.h"
#include "mex.hpp"
#include "mexAdapter.hpp"

namespace m_data = matlab::data;
namespace m_mex = matlab::mex;

union AnyPixel {
    Imath::half f16;
    float f32;
    uint32_t u32;
};

struct ImageSlice {
    int width;
    int height;
    std::string name;
    Imf::PixelType p_ty;
    std::vector<AnyPixel> buffer;
};

class MexFunction : public matlab::mex::Function {
    public:
    void operator()(m_mex::ArgumentList outputs, m_mex::ArgumentList inputs) {
        std::shared_ptr<matlab::engine::MATLABEngine> m_engine = getEngine();
        m_data::ArrayFactory factory;

        check_args(m_engine, outputs, inputs);

        auto input = m_data::TypedArray<m_data::MATLABString>(inputs[0]);
        m_data::String u16str = input[0];
        std::wstring_convert<std::codecvt_utf8_utf16<char16_t>, char16_t> conversion;
        std::string file_name = conversion.to_bytes(u16str);

        std::vector<ImageSlice> slices;
        read_exr(file_name, slices);

        std::vector<m_data::Array> images;
        std::vector<m_data::StringArray> precisions;
        std::vector<m_data::StringArray> names;
        for (auto &&image_slice : slices) {
            unsigned long w = image_slice.width;
            unsigned long h = image_slice.height;
            names.push_back(factory.createScalar(image_slice.name));
            switch (image_slice.p_ty) {
                case Imf::PixelType::UINT: {
                    auto begin = (uint32_t *)&image_slice.buffer[0];
                    auto end = (uint32_t *)&image_slice.buffer[image_slice.buffer.size()];
                    images.push_back(factory.createArray({h, w}, begin, end));
                    precisions.push_back(factory.createScalar("uint32"));
                    break;
                }
                case Imf::PixelType::FLOAT: {
                    auto begin = (float *)&image_slice.buffer[0];
                    auto end = (float *)&image_slice.buffer[image_slice.buffer.size()];
                    images.push_back(factory.createArray({h, w}, begin, end));
                    precisions.push_back(factory.createScalar("single"));
                    break;
                }
                case Imf::PixelType::HALF: {
                    std::vector<float> float_buffer(image_slice.buffer.size());
                    for (int i = 0; i < image_slice.buffer.size(); i++) {
                        float_buffer[i] = image_slice.buffer[i].f16;
                    }
                    auto begin = float_buffer.begin();
                    auto end = float_buffer.end();
                    images.push_back(factory.createArray({h, w}, begin, end));
                    precisions.push_back(factory.createScalar("half"));
                    break;
                }
                default:
                    throw std::runtime_error("Unknown Pixel Type detected!");
                    break;
            }
        }

        unsigned long count = images.size();
        auto out_struct = factory.createStructArray({count, 1}, {"image", "precision", "name"});
        for (int i = 0; i < count; i++) {
            out_struct[i]["image"] = images[i];
            out_struct[i]["precision"] = precisions[i];
            out_struct[i]["name"] = names[i];
        }
        outputs[0] = out_struct;
    }

    void check_args(std::shared_ptr<matlab::engine::MATLABEngine> m_engine,
                    m_mex::ArgumentList outputs, m_mex::ArgumentList inputs) {
        if (inputs.size() == 1) {
            auto input = inputs[0];
            if (input.getType() != m_data::ArrayType::MATLAB_STRING) {
                throw std::runtime_error(u8"引数は文字列でなければなりません。");
            } else if (input.getDimensions() != m_data::ArrayDimensions({1, 1})) {
                throw std::runtime_error(u8"指定できる文字列は1つのみです。");
            }
        } else {
            throw std::runtime_error(u8"引数は1つです。");
        }

        if (outputs.size() != 1) {
            throw std::runtime_error(u8"出力は1つです。");
        }
    }

    void matlab_print(std::shared_ptr<matlab::engine::MATLABEngine> m_engine, const char *msg) {
        m_data::ArrayFactory factory;
        m_engine->feval(u"disp", 0, std::vector<m_data::Array>({factory.createScalar(msg)}));
    }

    void read_exr(const std::string &file_name, std::vector<ImageSlice> &slices) {
        Imf::InputFile input_file(file_name.c_str());

        auto header = input_file.header();

        auto dw = header.dataWindow();
        int width = dw.max.x - dw.min.x + 1;
        int height = dw.max.y - dw.min.y + 1;

        auto channels = header.channels();
        auto channel_names = std::vector<std::string>();

        for (auto iter = channels.begin(); iter != channels.end(); ++iter) {
            auto msg = iter.name();
            channel_names.push_back(msg);
        }

        Imf::FrameBuffer framebuffer;
        for (auto &&channel_name : channel_names) {
            Imf::Channel channel = channels[channel_name];

            slices.push_back(ImageSlice{
                width,
                height,
                channel_name,
                channel.type,
                std::vector<AnyPixel>(width * height),
            });
            auto image_slice = &slices[slices.size() - 1];

            auto p_size = sizeof(AnyPixel);
            auto slice =
                Imf::Slice(image_slice->p_ty,
                           (char *)image_slice->buffer.data() - dw.min.x * height - dw.min.y,
                           p_size * height, p_size);
            framebuffer.insert(channel_name, slice);
        }
        input_file.setFrameBuffer(framebuffer);
        input_file.readPixels(dw.min.y, dw.max.y);
    }
};