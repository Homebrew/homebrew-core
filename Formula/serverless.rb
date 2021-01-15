require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.19.0.tar.gz"
  sha256 "dcb68255aad71b02c1d2f3b641b644a6fc00eccea5948e17a027e597a94a8d66"
  license "MIT"

  bottle do
    sha256 "7eb609f64aeafc843cfb0666098ae2023b5f66d34d1b9edf06e02e92caff2eb1" => :big_sur
    sha256 "163a170f2af6324d76c276532c8c35acfeed5df84642c4d040c12814ce95ef5b" => :arm64_big_sur
    sha256 "0b943af94a72e4ff57b428f8ef87efc37876303578a6f991323c2deaf4b0eb87" => :catalina
    sha256 "230ca2dab3ad9c16d30cf031acd594d1fad16c95f9112987c044ba709d7330a4" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
