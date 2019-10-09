require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.54.0.tar.gz"
  sha256 "23f3c8764d1136e4e2fdd44edd81e48f7d8325236f36567a7ddf6c57b5263195"

  bottle do
    cellar :any_skip_relocation
    sha256 "c087e88d9b67bd0aaede5051a21d3049cb6b246512892dfe1798748db1a76558" => :catalina
    sha256 "8355f4afcce7d13f16d4bce99ff93fde302ac6a8f576e2dff45f80e55a80ca52" => :mojave
    sha256 "5f59c6756743a2ab63de56d7458ec6f61bb46021570c6e424b53a44c6ae6d06f" => :high_sierra
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

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
