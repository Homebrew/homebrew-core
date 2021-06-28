require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.48.1.tar.gz"
  sha256 "3d9201db2a0bcd1d738175b539794c16efa8f2cb119a1aa4d079ac2a5456cb0c"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "b7c89b06daa78dddf5b1ef87d4eea53baf903b552385e0af6a9cb93c17b4abe5"
    sha256 big_sur:       "a8213ad78b84f638ee0e682b4041697db35a481446101e3e6bdf7e02f05e9780"
    sha256 catalina:      "b27908f545735d1a046c2cb5b4b480e8c65b8d09c4a7a970c12c91234e032356"
    sha256 mojave:        "28c968123bb6b259b190bc20b62cee660a24ea8e6475c58fecc45365fcfcc0b3"
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
