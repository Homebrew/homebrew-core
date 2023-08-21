class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.31.2.tar.gz"
  sha256 "33b8119181f04dffbb93b9c422c53cb8471f662edb814132bdad0aa28e3941de"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "669e2ca55b7b0c2a195ed848ae46d59a6e1a9446a8ee4ebd32f34142347acae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0a2f616e22328661b54ab38802a441e5f39a5d2249f36e5e468086ec8708da7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4e30d3d9a2eb1aae5b61d58cb969ac6cf7439f9447bb476bb7eea1210a71af7"
    sha256 cellar: :any_skip_relocation, ventura:        "a9dcad10a8a3ffb076e02041d1b3208801c0f10726ffa4b390f82428258c65f4"
    sha256 cellar: :any_skip_relocation, monterey:       "b0b22122eea5aa513bc4e581edde93820fddf4d8749a36a9ad4afc0576dc644b"
    sha256 cellar: :any_skip_relocation, big_sur:        "29a0f0d71e9f9c4c97d2bb48f702040b23459a3158c0dd0a979d9d14d214b3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c49cba49db08fe881a3226277d98127c0d62e4fce2bcc6575346bd435928e6"
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
