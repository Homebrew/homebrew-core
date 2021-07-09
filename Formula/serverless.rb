require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.51.2.tar.gz"
  sha256 "54275ec93d1e4ffd692ff73ecd69945a0acc11ef1db89ff16fe27d08c1b9653a"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "90cae0a6d14d28d2c065d754f4cb466ea434c49e8a7da7b52535fe78a5c9aff0"
    sha256 big_sur:       "c06c3c6bac2aff5445a06a4edd6790069e20b633330c956aa2f0bcba3a6b1faa"
    sha256 catalina:      "e1a73d6cf2b403607f52697660aa7b24f4d722e1566f502414db33604f95cd0b"
    sha256 mojave:        "03ff30c705b1c2e4f18fe58a1a2a754ea01285a420e864cb613e37296f777f59"
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
