class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.8.0.tar.gz"

  sha256 "7f3179905a3bf725e34a85442ef30880c350659525e750a9112f3fefa23123b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9b6d238321b849c11cd0ce4b498f6f999626c5e93b3bac8ad98d185b2ef7d28" => :catalina
    sha256 "af674ab002d471996f266faf60585d7c4a5a673dbbf4d44cc0c4dd84e78ea8bb" => :mojave
    sha256 "f1ef3174a5185d84256c33b8e6b7d1da791e51da53e4f549afd266b66a6bb763" => :high_sierra
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
