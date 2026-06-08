class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "f8e632016ceae556f3132a16c7f704be1e7715595041f474fa81a2b64c1abf7c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b428e507b91af7e6a787126c7eb6907e5631df3cd91a8c39a85c0609cfbca064"
    sha256 cellar: :any, arm64_sequoia: "0d7906b1b1b2ce055449a0baf59c3c2e65e54815d1185628412970a9b9f38fb2"
    sha256 cellar: :any, arm64_sonoma:  "80847178e436feead3a3a767d73d9154b75843e9f7e2269cd3cd452834f66084"
    sha256 cellar: :any, sonoma:        "6287b9afef7f020d4072441f328d00d4f31c07c79dd16d8b18d7a6489829a687"
    sha256 cellar: :any, arm64_linux:   "67f5ac4b9404c606a42d58ae4eeee4b4af751bcae4c9927ae36b62a1395043c5"
    sha256 cellar: :any, x86_64_linux:  "7c50a5dc071efbc3bb725c141fe4ac1539833958f2cbe02f779ced44bac8d3aa"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "ggml" # NOTE: reject all PRs that try to bundle ggml
  depends_on "sdl2"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWHISPER_SDL2=ON
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
      -DWHISPER_USE_SYSTEM_GGML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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

    flags = shell_output("pkgconf --cflags --libs ggml whisper").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
