class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.6.0.tar.gz"

  sha256 "d704710315898aae5b48e6738609d41ccc51c72a163bbdc31024007a6b438408"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e4e2ad188da30e4110d2b3a3e05f3ce72a82db3ca4a17049f0cc298b27b8b14" => :catalina
    sha256 "82e31191057158baaaa3e8765e718be80d4ab40693895fb37bffc62152294c26" => :mojave
    sha256 "4a81737917f2123301de1d9ab6dfd1ba5a44ac78150d53510c3a2a2bcbab4956" => :high_sierra
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
