class VapoursynthMlrt < Formula
  desc "Efficient CPU/GPU ML Runtimes for VapourSynth"
  homepage "https://github.com/AmusementClub/vs-mlrt"
  url "https://github.com/AmusementClub/vs-mlrt.git",
      tag:      "v15.15",
      revision: "112fcbaf6e5d648b9c15ba7b55b54c896a884b61"
  license "GPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "onnx"
  depends_on "onnxruntime"
  depends_on "protobuf"
  depends_on "vapoursynth"

  def install
    args = %W[
      -DVAPOURSYNTH_INCLUDE_DIRECTORY=#{Formula["vapoursynth"].opt_include}/vapoursynth
      -DONNX_RUNTIME_API_DIRECTORY=#{Formula["onnxruntime"].opt_include}/onnxruntime
      -DONNX_RUNTIME_LIB_DIRECTORY=#{Formula["onnxruntime"].opt_lib}/onnxruntime
      -DENABLE_COREML=ON
    ]
    system "cmake", "-S", "vsort", "-B", "build", *args, *std_cmake_args(install_libdir: lib/"vapoursynth")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
  python = Formula["vapoursynth"].deps
                                 .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                 .to_formula
                                 .opt_libexec/"bin/python"
  system python, "-c", "from vapoursynth import core; core.ort.Model"
  end
end
