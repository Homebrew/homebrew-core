class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.19.0.tar.gz"
  sha256 "ff600937c122820572f718def7ad5b623fea5b4108d985bc367519364ae6b16b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "119cc1700e7c18bcca61e637a2a88c9058de42b711eadf22367c9479e7940054"
    sha256 cellar: :any_skip_relocation, big_sur:       "6deafc37752f59a57f042a8aa7c37abbc0a383d34117ec60f8bdcc517c18d24e"
    sha256 cellar: :any_skip_relocation, catalina:      "26d8781cd27fee60e2d9f4962ea9a3401cf55395906d1bc6958c324243374d13"
    sha256 cellar: :any_skip_relocation, mojave:        "47a530f97f9896db3b4c4c1541f799da793621191d9c57bb8e9e6d49572ae0da"
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
