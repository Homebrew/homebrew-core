require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.51.1.tar.gz"
  sha256 "17f817ebd8394f53de4d0b7694ec2c981495dcde6f42cc64bd24afb73683f785"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "991ac4debc74abe84b62be286b5d7cfacdef0ea41af4c8b3395d9f3650e6a7ff"
    sha256 big_sur:       "1e8707900a6a6f52fe848ee6ae4a1c65d12fe98ccc18d734235a8370b7a39e20"
    sha256 catalina:      "5e8a36976730d959fa13ca01e9c8c2b1ef6b598aa4bb627b432f1eda588cfd3f"
    sha256 mojave:        "a0d8a2823c80ddd658ab57c39c330d79dd3794582172cd279ddd711392986971"
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
