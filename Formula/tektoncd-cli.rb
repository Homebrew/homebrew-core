class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.31.0.tar.gz"
  sha256 "eed5225f841c035113b917a72a96e4ba42dec5aa1af039497db82be9f765f341"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a93ec7148f01c45fdc1df5356225d1ab2ca434123a852ce303ca6ed97344b2a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48429403ab530b51ded54610c3d5360f39b7433688f7cdcbd55bc8417f7fd6ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec2b5fade6921d838c77a593d677805c0c036cac9f32fd98641c77eeae645095"
    sha256 cellar: :any_skip_relocation, ventura:        "8988ca862af56cc50a18ea665cfdf9c7bc971bc38ad070c35a260f2150ad6113"
    sha256 cellar: :any_skip_relocation, monterey:       "6a24c66282567323833882189a99f24a5227404c12568e527cd4f77dbf057005"
    sha256 cellar: :any_skip_relocation, big_sur:        "533f5c10060d65b7563fe9e9dab005af82ac10bb7048c506c4f48842599b3a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58df984f115a93342d6d70f169bbfcc550f863f5fb5dbc662dca37c43333b35b"
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
