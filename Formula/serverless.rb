require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.78.0.tar.gz"
  sha256 "4bbb6d0b7d73fe3c8dd0755906f42dd2ff745049d69fecc1bb4d9719ef06ccd0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "abc6e52b31e13dfdc0f6172284dfc676e38ba83848d04a7902b1ea8fab23d3a6" => :catalina
    sha256 "0f68c20530449a3580b4e0c0a837bc724365a6f48c31c5855a301fcc397f1033" => :mojave
    sha256 "0cee8aa72b413431a852e0dd694db568483c8ba0085d66224ad9dbe1a9eef957" => :high_sierra
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
