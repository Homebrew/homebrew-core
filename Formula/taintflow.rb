class Taintflow < Formula
  desc "Offline Static Application Security Testing (SAST) tool using context-sensitive taint analysis"
  homepage "https://github.com/h3lium4u/TaintFlow"
  url "https://github.com/h3lium4u/TaintFlow/releases/download/v1.1.2/taintflow-cli-x86_64-apple-darwin.tar.gz"
  sha256 "396798584a693de80fc456e9f5ad0a14c14b694cb1689acaf59bee556e1a7450"
  version "1.1.2"
  license "MIT"

  def install
    bin.install "taintflow-cli"
  end

  test do
    system "#{bin}/taintflow-cli", "--help"
  end
end