class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggerganov/whisper.cpp"
  url "https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "2fda42b57b7b8427d724551bd041616d85401fb9382e42b0349132a28920a34f"
  license "MIT"
  head "https://github.com/ggerganov/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "60f2a5715f633cdb5a86adb6ccf8e4dc553c5b5e97839019d4edfb3151993da9"
    sha256 cellar: :any,                 arm64_sonoma:  "1fa55cf16d944d91ddb145c592bb9327a262124ab9b93e9e32191e728a0d05c8"
    sha256 cellar: :any,                 arm64_ventura: "6029b6487ab798002960ce9d37488a2dece0fa0706f87b773d30a8dc5fb61357"
    sha256 cellar: :any,                 sonoma:        "8f43095a43f99de996b6c5d45319022cc27b9ac75774dd3b201e0a7fb3602dbc"
    sha256 cellar: :any,                 ventura:       "3eedd879a4ae545461f70d1c2b7c4e318e5696fdaf7fde8d2dcfc56281d1fcf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "806baa21a25b3ca1fe8b1a69e201bdf34fce95e9bfa0ddd6a118037099f31c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e5f09c4f11f4b1507f4d726c208523b4a1f360d11e454ee3c273b427cad2fc7"
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
