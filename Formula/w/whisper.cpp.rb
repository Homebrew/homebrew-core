class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "7ab15dc88022d2425ad94dcffd8abbf1b6d7018089b4e48d6b40780738e0b445"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "3e2e1ec1eb2ad0a973c14c972c85f03d9f618fa3648168881fdb1a9b1a7d72be"
    sha256 cellar: :any, arm64_golden_gate: "d117c2ce6d54f7c47dcb8bd245165bb0df3a1434ac126d5d7ba12f3fb8dc641b"
    sha256 cellar: :any, arm64_tahoe:       "8399aa3bbc282efe6b063cc3c97952b41ff117e309f79b5cf0f9e6f40944f46a"
    sha256 cellar: :any, arm64_sequoia:     "0e028d24f8e0a5d7bf7f8167d81d6034458228dbe75fc17e1a1ed1e07390efa4"
    sha256 cellar: :any, arm64_linux:       "424d67446e4fd2f0a7ae331ccdc8e002f93ca9f7c643e44995d1e6f3f282e798"
    sha256 cellar: :any, x86_64_linux:      "6792fe5f842d493a0e86edeee2b865baa276299a9edeaa8fc1ddcbb4d132bf03"
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
