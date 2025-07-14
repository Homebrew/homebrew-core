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
    sha256 cellar: :any,                 arm64_sequoia: "29883368e3c7eed0babb482ed2e01d39a92e563e36cd35f79330680df2e257ee"
    sha256 cellar: :any,                 arm64_sonoma:  "78f3de18bc9b26525c423341487192458de6f6f7c1e0a3d8c0ad9aafe0b08f6a"
    sha256 cellar: :any,                 arm64_ventura: "cbff2b56f8b93e037c155d8f5a564c6f8f19c8e3f73e499aadd320b76f14285f"
    sha256 cellar: :any,                 sonoma:        "4a7b8c7e69d6c67d15141b6088a58c12b0437f710fbe62fa71b3eaa355201151"
    sha256 cellar: :any,                 ventura:       "767a6156cfa00c09d1f0fa5dd23b4395526e248609fd3235f3d6f1d61d6976d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29bbaf44240b251477cd81018e45f0c6abb0bc4df1191e67aceb6ca49028c19f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f047b76ea1ad79bf18d9cd7c4535a4d8fc0379741db733f898e0564885d988f"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath(target: prefix/"libinternal")}
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
    ]

    # avoid installing libggml libraries to "lib" since they would conflict with llama.cpp
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_libdir: "libinternal")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # avoid publishing header files since they will conflict with llama.cpp
    rm_r include

    # for backward compatibility with existing installs
    (bin/"whisper-cpp").write <<~SHELL
      #!/bin/bash
      here="${BASH_SOURCE[0]}"
      echo "${BASH_SOURCE[0]}: warning: whisper-cpp is deprecated. Use whisper-cli instead." >&2
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
  end
end
