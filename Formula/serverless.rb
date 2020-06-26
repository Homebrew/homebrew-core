require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.74.0.tar.gz"
  sha256 "48af008f5b158ab23e019e49911d16ff7664b4e797e0a885427c92426e4de2ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "aac3137aca6d637c2ba9f1cbe03793abfab5e44e33c68004c76ebd7b66a75d53" => :catalina
    sha256 "0bf1c6446c96a60b7896db9513c6662a13bf073c7b38b2c29cc98943c1f8adbe" => :mojave
    sha256 "d610e5c1ae0e53b57ee7950704cf3f9beb53897098c89589a78d01bf28ed1ffb" => :high_sierra
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
