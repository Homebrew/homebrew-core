class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.30.0.tar.gz"
  sha256 "377e54a0d861a43216ecb63eddd2815ef3fb8f3e514eac6ad22cd9f148132642"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea184de41ff07c894bf5e6c519af414f012800164d744a4985a73b48c990a735"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "283c1773f6151a20caa19ef700e174a6d44152db80a7dca5d4d06b58d70f6989"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baf842cc8c6d992cbd05c0874cb157df6acaf08b97cb7f903c3342e818e9fada"
    sha256 cellar: :any_skip_relocation, ventura:        "e06ebcd0e59d78ef4481ff0b86d46b512c59493bacd17355865c7d215161e7e1"
    sha256 cellar: :any_skip_relocation, monterey:       "b596347a4c50ecff98bcce10ed55a455170782dd82d5b55e013568e4c813fa84"
    sha256 cellar: :any_skip_relocation, big_sur:        "df88e19c6be6194e99fc23b35d4ca5907776c89f4ab2e3fed432327496ee1ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b05aac6ae50db51b434ade5ab1718b018e66c09f83d2a285021093c8a219c3"
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
