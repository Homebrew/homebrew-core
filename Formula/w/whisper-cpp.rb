class WhisperCpp < Formula
  desc "Port of OpenAI's Whisper model in C/C++"
  homepage "https://github.com/ggerganov/whisper.cpp"
  url "https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "be9c4d5d4b5f28f02e36f28e602b7d2dcfd734dd1c834ddae91ae8db601e951f"
  license "MIT"
  head "https://github.com/ggerganov/whisper.cpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4f251448c98efb0b88003e8e3b4b93611e4353908ffcc8fc1a7637e22c0b6ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc964f3b003ea43f3177e48d7f87ef68cfd326ef0016ad74646791a62e6a66ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e839aaba75ab65c73ef1b8f9d42661d6f79c53a222f2fefb04bfb1acc768eeef"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca56bc64924c25e7363e9739fcf6252185b62f4e759e641de87d84fea578cab9"
    sha256 cellar: :any_skip_relocation, ventura:        "1ceb65d163ce533d3ca017ac129054554e5fbe71d9f48baac49a489dd4b74eee"
    sha256 cellar: :any_skip_relocation, monterey:       "537a883322a52426b1429480064758615d72655ee5fbebf35552e08dec6406e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ffbf5e6c7a972d7482e1ef24e93d87022903f341f8450a279b42589c0052be"
  end

  def install
    system "make"
    bin.install "main" => "whisper-cpp"

    pkgshare.install ["samples/jfk.wav", "models/for-tests-ggml-tiny.bin", "ggml-metal.metal"]
  end

  test do
    cp [pkgshare/"jfk.wav", pkgshare/"for-tests-ggml-tiny.bin", pkgshare/"ggml-metal.metal"], testpath

    system "#{bin}/whisper-cpp", "samples", "-m", "for-tests-ggml-tiny.bin"
    assert_equal 0, $CHILD_STATUS.exitstatus, "whisper-cpp failed with exit code #{$CHILD_STATUS.exitstatus}"
  end
end
