require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.14.0.tar.gz"
  sha256 "77c8a6ab34ea755a0db0e4e2c50a66a209772b4f2f2fb7a7307375f8c0f91fdf"
  license "MIT"

  bottle do
    sha256 "01940facf0e14ae0e91f8bf7427dbc833d39ca825af37d227b6ba4639572d895" => :big_sur
    sha256 "6bd4e4c8eddbae3abdf94f4daaf1071c949aee158408bfee6dbae954b913e077" => :catalina
    sha256 "055a696108e63140ef34e3b7d2a9a7497c5ba07d0dbd6dc3726960c9cec18891" => :mojave
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
