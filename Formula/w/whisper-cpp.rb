class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "c006a5e472ee41e7a733d0bf7326e339c8b281d3a91a1c8a35468fa0a051940f"
  license "MIT"
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af01745d8e901da2e15a2762cfb5b0b45f86c440f547e138967e881756871d5d"
    sha256 cellar: :any,                 arm64_sequoia: "3e7bf9cc5ad26440353f021aa212a99bb7a5b73c3ab5104f09568567c4056269"
    sha256 cellar: :any,                 arm64_sonoma:  "efda95b09b4a26cbf42b20f7f88a961aed922346f88121a7a4bfe93c31a2f8f8"
    sha256 cellar: :any,                 sonoma:        "ead085a1fad2849b756b80b7df4ef0f83fb934aa1adafb3cb4675f0fd6e2fb8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73074b46e46d34be9041e519c5612b1a60882fbdbaefa2d663a22a478596a737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d9fd2a0ba02cb3e8f7933e6a6e3b4d6270083ed4cb1fb847b576b483b7759f"
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
