require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.51.0.tar.gz"
  sha256 "afb2e212c03de929e8bbe27ba9c1abce0b66b26b0d639037fe559ec8ba530711"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "8d767792113181bf1d0a99be33bb9e400b285903652633cb9f1a35ef73ea4848"
    sha256 big_sur:       "f6d6e08bddaf741041767d7ced80475c88bf0ac1d35fc67b95d40269dc5de973"
    sha256 catalina:      "26cafee94be6382df0702d2fc1b042a187bb6ad3cc0cb441bab3c967906afee3"
    sha256 mojave:        "f8677c55463a88035a3c49108e248f7116dc7851fa82fb86a2df5deb65a65bb9"
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
