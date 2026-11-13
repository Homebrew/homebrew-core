class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "ff1a9053feb509ff9d7729703355541ae9690073a6b1c40eb692c962e0dc1720"
  license "MIT"
  revision 2
  compatibility_version 1
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d1b38766f30e6eb78c502ec9fab921b39838fcd10fe084b9bff4d335ed592557"
    sha256 cellar: :any, arm64_tahoe:       "7ac257aafd3586b79ed3be9cf150b3650c2f94a097c9dce9a75139914cc4a429"
    sha256 cellar: :any, arm64_sequoia:     "5a28079052309e287e3f7d98ddc74f3f5ee2f2a31bce193f6e1ac068de79dcf5"
    sha256 cellar: :any, arm64_linux:       "0d8d7ade355581a9bb7dff7c9306e7e3c52252f0276aedee19227f2315d33cde"
    sha256 cellar: :any, x86_64_linux:      "dccee89fee5df5013d5cb8008a38142cfeb3f4d3f924786667ea77fa71981940"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "ggml" # NOTE: reject all PRs that try to bundle ggml
  depends_on "llama.cpp"
  depends_on "sdl2-compat"

  # Support new llama.cpp
  patch do
    url "https://github.com/ggml-org/whisper.cpp/commit/63ae1b5f55b5d56622b39b3c01a4710feb57d844.patch?full_index=1"
    sha256 "4422ba043e70622ba20c5c8dfb614680fb7c88229c9e398dffea098b5d12d65c"
    type :unofficial
    resolves "https://github.com/ggml-org/whisper.cpp/pull/4173"
  end

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
