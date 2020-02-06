require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.63.0.tar.gz"
  sha256 "84532070b583d8484935a76800de3ee99e9e633b02162e526ab0371cda8aa28b"

  bottle do
    cellar :any_skip_relocation
    sha256 "05d2fb236605a4f5c70e9355e3e179961b323a5ebfae11c29dd79a012a13c722" => :catalina
    sha256 "574bd50e42d0bdcc81f6005eb68787872157677b7b2b51397c2344285db56658" => :mojave
    sha256 "091e346c715c00023ec7b0d2ecc91b7315cc381eb21d5c26b8f0392ff3332acb" => :high_sierra
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
