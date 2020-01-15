class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.6.0.tar.gz"

  sha256 "d704710315898aae5b48e6738609d41ccc51c72a163bbdc31024007a6b438408"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ed90b363732733b905ddd4772694b6e1d2fa577aa8d291af4bd3aec3b88f355" => :catalina
    sha256 "623f0b26996c448ffa10a69b317820ffec384350568b7e92898c0713a6b11a3a" => :mojave
    sha256 "b12a66ae2d46fec35a76195bf8c985ef7fe531dd8969e1c59c29160e961070ce" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"

    bin.install "bin/tkn" => "tkn"
    output = Utils.popen_read("SHELL=bash #{bin}/tkn completion bash")
    (bash_completion/"tkn").write output
    output = Utils.popen_read("SHELL=zsh #{bin}/tkn completion zsh")
    (zsh_completion/"_tkn").write output
    prefix.install_metafiles
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, :err => [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
