class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggerganov/whisper.cpp"
  url "https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "a36faa04885b45e4dd27751a37cb54300617717dbd3b7e5ec336f830e051a28c"
  license "MIT"
  head "https://github.com/ggerganov/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9b74a43600aa765826b7a79cc06c025070ffd7cce932f493240abf6cc21824"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6fde059a1cc222038be70d762ebe1f75e31121c7246410d1bd1063e96e4b342"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10f789f5dbdc8c0e3adfe15cea91d2437f7922c1cd21bb7e788896d5213fe53a"
    sha256 cellar: :any_skip_relocation, sonoma:        "64a4ec07c1191f7313ff8be9681ef20859deac638707a9a89da6a683720d9674"
    sha256 cellar: :any_skip_relocation, ventura:       "a00e4c6ad15c44c89a72172599179e41c226e9cbb3d87751dc0a48303cbf668e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3141b812e243e19e5a0acef2841e683c1564dd29f15ed3208f9483b59886611"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=OFF
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DWHISPER_BUILD_EXAMPLES=ON
      -DWHISPER_BUILD_TESTS=OFF
      -DWHISPER_BUILD_SERVER=OFF
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    # the "main" target is our whisper-cpp binary
    system "cmake", "--build", "build", "--target", "main"
    bin.install "build/bin/main" => "whisper-cpp"

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
    system bin/"whisper-cpp", "-m", pkgshare/"for-tests-ggml-tiny.bin", pkgshare/"jfk.wav"
    assert_equal 0, $CHILD_STATUS.exitstatus, "whisper-cpp failed with exit code #{$CHILD_STATUS.exitstatus}"
  end
end
