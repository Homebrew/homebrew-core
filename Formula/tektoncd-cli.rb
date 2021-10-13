class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.21.0.tar.gz"
  sha256 "c6fed13ddd0cbb410230cf85749458a42b9cb8d56ad6ec48b44e70e26cce9062"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ce190179c039a659fdd56db1dfd61ad653ec6f9de6c6aa9950b9a068e5a22ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "2340e7366bb268236ee9e2e8c3172712534e547f066ea1b13c4882c7b8014af0"
    sha256 cellar: :any_skip_relocation, catalina:      "f3bc8b676c7055a244760a82d1b64631327dc4f66e04d5c254c8669250a650c7"
    sha256 cellar: :any_skip_relocation, mojave:        "19b2eb7fc9058bb500c33b1f9e60f740627d7740ce6201bc9408a3bd6658b834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c546dd97f355278764d8a2c9566c2eebe33b7d5890eda1cba903aaf6a03bf0"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"tkn", "completion", "bash")
    (bash_completion/"tkn").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"tkn", "completion", "zsh")
    (zsh_completion/"_tkn").write output
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
