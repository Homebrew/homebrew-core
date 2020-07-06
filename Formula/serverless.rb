require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.74.1.tar.gz"
  sha256 "823a5c163c74fc8b4953a44110e9b2591f64d53cb56b69470db9e132811dd477"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a913b1376246320ab7cf17dc15e0c6de5534e1baedf78345a5b6cb26e5b33d43" => :catalina
    sha256 "28fbe12a792588c47479e897500011b60a2ec04b1b2fcc1f2860641968e6ed6a" => :mojave
    sha256 "c47587d66949e0a511441c0d388ec9dc4a1804f7fea4963c22752e653644d641" => :high_sierra
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
