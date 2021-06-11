require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.46.0.tar.gz"
  sha256 "dc87e702a41742ca3eba9292e0f158182179d9a6559f68ef52ee7cf522f205a5"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "44c3653ee0984bdc18bc8e8af5264b41cac5e628e8d47c04240c526341a388b5"
    sha256 big_sur:       "7d5b73413c53ccf18b558689ebdfcac3bbfa9b5034827acb009eb4885a2cd3b7"
    sha256 catalina:      "43d3d549ad415786a2aee7e04c47d24ec647312b647e6ec03541c910045b7302"
    sha256 mojave:        "48c1499074057897da8d39ee0f10bf13909b5350edada0ddd474078fc92d0ede"
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
