class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.15.0.tar.gz"
  sha256 "fceab0b1549d941915523b2cbf4dd08d621b06aaf034f8a5e087775283341a18"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e90af6e0d7fc8533aad0ae19fc8c3cac4dab35147fe0fbf974d476d1b68155f6" => :big_sur
    sha256 "b03a9381beeae6ab39ef985f6f2b942d8d5f2d87aa3a8422a89c0618666fc6fc" => :catalina
    sha256 "3696110f0181ea34fbdae9ba9ee10d09ba9003f7c6ece96f04949829be3dccd4" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"

    bin.install "bin/tkn" => "tkn"
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"tkn", "completion", "bash")
    (bash_completion/"tkn").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"tkn", "completion", "zsh")
    (zsh_completion/"_tkn").write output
    prefix.install_metafiles
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
