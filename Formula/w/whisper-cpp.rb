class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "b26f30e52c095ccb75da40b168437736605eb280de57381887bf9e2b65f31e66"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fca60c843fa6658257b7a7664eb7d47b84ddb5439e76ffc3c2d9aaf3c58c1c83"
    sha256 cellar: :any,                 arm64_sequoia: "d794efe84571c76ef12c49c09298c3607034957b71c521eacc1cd31f63321ce3"
    sha256 cellar: :any,                 arm64_sonoma:  "188da204b568997bb9d9536a7059c85de3225bcdba14a0cd57042c4fc750d3a4"
    sha256 cellar: :any,                 sonoma:        "e0a6d4f8cb3e1fb7a31185c31fef44741e068af4632b46226c1a4a0f545b3e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e42db9f12aa9c39d0238717f29d568464b10ae6fbcca6c0a03d3a7d6760be9aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1932e53d5a3c28174411c00939d2c74e3c328a07b8e62b75b3e90053b114629"
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
