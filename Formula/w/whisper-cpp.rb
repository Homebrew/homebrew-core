class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "bcee25589bb8052d9e155369f6759a05729a2022d2a8085c1aa4345108523077"
  license "MIT"
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cb50399576f2aa6a88de95f5bb7635065b0235619f8d3f196753d8009aabfd3"
    sha256 cellar: :any,                 arm64_sequoia: "a5ae48613187e5607b0d3338e7fea58ae1107a14de85d6adb5a3f07fc49c9724"
    sha256 cellar: :any,                 arm64_sonoma:  "5d70c696e7a8e20375915f7565745d07c5d8cd2725595f172bf6cf6b46318b2e"
    sha256 cellar: :any,                 sonoma:        "48518a1190475e02f7e1f5fe9adbd813f73ff91b3fb55b1834c0ce8ac4f94ea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b2df7c96d567867f3114a3a4326c6d08cc37c98588cb58a0c8d6188ca296297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4847bfe03f4be61bd1a364e6bddb259160d09de148cc870ab06058412359b57"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "sdl2"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DWHISPER_SDL2=ON
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
    ]

    # avoid installing into prefix as ggml libraries/headers would conflict with llama.cpp
    # TODO: change this once ggml has releases, https://github.com/ggml-org/ggml/issues/1333
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Expose executables and pkgconfig files
    bin.install_symlink libexec.glob("bin/*")
    (lib/"pkgconfig").install_symlink libexec.glob("lib/pkgconfig/*")

    pkgshare.install "models/for-tests-ggml-tiny.bin", "samples/jfk.wav"
  end

  def caveats
    <<~EOS
      whisper-cpp requires GGML model files to work. These are not downloaded by default.
      To obtain model files (.bin), visit one of these locations:

        https://huggingface.co/ggerganov/whisper.cpp/tree/main
        https://ggml.ggerganov.com/
    EOS
  end

  test do
    model = pkgshare/"for-tests-ggml-tiny.bin"
    output = shell_output("#{bin}/whisper-cli --model #{model} #{pkgshare}/jfk.wav 2>&1")
    assert_match "processing '#{pkgshare}/jfk.wav' (176000 samples, 11.0 sec)", output

    (testpath/"test.cpp").write <<~CPP
      #include <whisper.h>
      #include <cassert>
      int main() {
        ggml_backend_load_all();
        struct whisper_context_params cparams = whisper_context_default_params();
        struct whisper_context * ctx = whisper_init_from_file_with_params("#{model}", cparams);
        assert(ctx != nullptr);
        whisper_free(ctx);
        return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs whisper").chomp.split
    flags << "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
