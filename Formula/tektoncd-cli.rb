class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.8.0.tar.gz"

  sha256 "7f3179905a3bf725e34a85442ef30880c350659525e750a9112f3fefa23123b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "957f2b7fca0ca4dd9771424414d487bf17a99cfec72287ae8ea8f890e7436902" => :catalina
    sha256 "ae2e0d06f6a7469e8203a0116aa134d2cf6d5061acb7cbda4c4d42fa377a2201" => :mojave
    sha256 "a4a0f3b056562799e295f4571058f9139af9783fb7d3fb38a1ae93b912d983ee" => :high_sierra
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
