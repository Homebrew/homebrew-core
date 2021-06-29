require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.49.0.tar.gz"
  sha256 "3c8d336d9763352b049a98bbb4147d6161bcd26177e430dda4121d608606c59c"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "464192a0cc5f36a2c3338c0f0aaf1a56c7ac90c7d40bbc574825bfa84480061d"
    sha256 big_sur:       "617d7bb485b47343cdf99c0bfae576bdb18180aaee160807620d9e628440379a"
    sha256 catalina:      "337d967c29a07cd4c88bc1d9509d00f84dbbf14800bae492225519b8118e3a95"
    sha256 mojave:        "1817ba157b7108ac743d3b951414aec32089c082faa71e795401488c83346194"
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
