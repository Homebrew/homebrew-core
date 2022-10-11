class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.27.0.tar.gz"
  sha256 "f6da1fe30c77eedef1ecc1dfd53fe3b64d959e753d07a2a24b383fd637ca1367"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1e957261fab70713f7ee24080865a7fd8b5b77a6c7f2a400186b82bc809d40c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "911bf4af0ac77c81b97c6220d85da151d8cd4adb9f5fda7a2299e0c66a455574"
    sha256 cellar: :any_skip_relocation, monterey:       "69dfce4e130d0a776cebda96fe9b8b6eebce4151ec0f958c41f8dc4cb5e024f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ef91383ee4deb09adc7eaa3530dac0a8a6cc08c8d8e20ef64e8aa0b3fbecb61"
    sha256 cellar: :any_skip_relocation, catalina:       "7eeedbb88b6a0cd7192421626325148b702a15e12cfaa2e6617f9c91d208cd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f02028301f67c8e4fae2c335c92f46ab72bd318b411548b61eda30985ac1fa29"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
