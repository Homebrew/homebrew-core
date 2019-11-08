class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.5.0.tar.gz"

  sha256 "b38e8560c0144e0288ed2538ab864c9e081eae36b8adc28530806d9171cd0a64"

  bottle do
    cellar :any_skip_relocation
    sha256 "97205827393ba9f2c9de2b3a002c3e18474f7570352d07442212c57d85b560f8" => :catalina
    sha256 "8e4a430598fbb4d68fd60c3147fef4cb582b23a7842670556cb9710e8f417008" => :mojave
    sha256 "65bb6ba4faaa0e99fa924360f837787f29e5e1b53c13fae02308c15e59379863" => :high_sierra
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
