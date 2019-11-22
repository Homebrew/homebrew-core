class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.5.0.tar.gz"

  sha256 "b38e8560c0144e0288ed2538ab864c9e081eae36b8adc28530806d9171cd0a64"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a154049eb8947614384d65e2ee0fff7989ded628b218c67471c8ac4c23a7c89" => :catalina
    sha256 "9b035305086657916025f7592b8ae1d764d0eb827ebfd526cbb8a75872757707" => :mojave
    sha256 "bcda821209b372945513cb82a5296865b23d281b6d1d5063aeb9264ad6ac80e8" => :high_sierra
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
