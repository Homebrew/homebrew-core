class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "ff1a9053feb509ff9d7729703355541ae9690073a6b1c40eb692c962e0dc1720"
  license "MIT"
  revision 1
  compatibility_version 1
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e44296ed9c6d2ef97d08c4fd584f3ec648cfc5855fc1aebb205d4d095878172e"
    sha256 cellar: :any, arm64_tahoe:       "1b28da297367ecbd4a819d1683028d4ee443a1ea879d67059573c130ec2cbe3c"
    sha256 cellar: :any, arm64_sequoia:     "6928249d28f1855323280f9a8fe3963a9703814878a7f7345d6e4e2ca7394f59"
    sha256 cellar: :any, arm64_linux:       "7c5880687356b963d22b644e0df899e8025ae0dda50226e9b3908945d9ac5ec8"
    sha256 cellar: :any, x86_64_linux:      "b56724e7c6e522895f06f45e18817e9e384551754b4e1b9d09d6b1bb4ada1aa7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "ggml" # NOTE: reject all PRs that try to bundle ggml
  depends_on "llama.cpp"
  depends_on "sdl2-compat"

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWHISPER_SDL2=ON
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
      -DWHISPER_USE_SYSTEM_GGML=ON
      -DWHISPER_USE_SYSTEM_LLAMA=ON
    ]
    args << "-DWHISPER_BUILD_IS_DEV=OFF" if build.stable?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "models/for-tests-ggml-tiny.bin", "samples/jfk.wav"
  end

  def caveats
    <<~EOS
      #{name} requires GGML model files to work. These are not downloaded by default.
      To obtain model files (.bin), visit one of these locations:

        https://huggingface.co/ggerganov/whisper.cpp/tree/main
        https://github.com/ggml-org/whisper.cpp/tree/master/models
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
