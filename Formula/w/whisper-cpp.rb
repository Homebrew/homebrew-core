class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggml-org/whisper.cpp"
  url "https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "166140e9a6d8a36f787a2bd77f8f44dd64874f12dd8359ff7c1f4f9acb86202e"
  license "MIT"
  head "https://github.com/ggml-org/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "c09bbacfe6dc6a49f351d674dc6a207881d33b677322e36cea228c81f73fcd16"
    sha256 cellar: :any,                 arm64_sequoia: "c06e2df81e481d21d041b2359f4e4a5def132854953c1866bc1366f338ef3766"
    sha256 cellar: :any,                 arm64_sonoma:  "4b5ac49039fad3567a76cbce49658aa54000e13f6e19738b7d85e29239559ad5"
    sha256 cellar: :any,                 arm64_ventura: "3eead42cfcafc558679fb9a0f0c5e566ac62428ef4304fdc3eb1208e77392929"
    sha256 cellar: :any,                 sonoma:        "79f2d1f047cf8412e0f81d8d50bfaf5902f26ce27a217d9ee428f8426bf8daf7"
    sha256 cellar: :any,                 ventura:       "ae15cc17825603c006f9451a7dbdb2d39aa02a287776baa534af3917d497201f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ca8140c5ef5a2fe5cb1803319bf96b447df01b3e85c68a5e2ac367a6ec10319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ea46f12511f444b3e4dbb9bbd0b32dee68766b147ff708265206899b16bec9"
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

    # for backward compatibility with existing installs
    odie "Remove whisper-cpp script and libinternal" if build.stable? && version >= "1.8.0"
    prefix.install_symlink libexec/"lib" => "libinternal"
    (bin/"whisper-cpp").write <<~SHELL
      #!/bin/bash
      here="${BASH_SOURCE[0]}"
      echo "warning: whisper-cpp is deprecated. Use whisper-cli instead." >&2
      echo "warning: the compatibility script will be removed in 1.8.0." >&2
      exec "$(dirname "$here")/whisper-cli" "$@"
    SHELL

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
