require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.72.0.tar.gz"
  sha256 "bd00ac97ec68b81c1621d45d6f236d2f3c022f597cf81d7f281c2377d62bfed4"

  bottle do
    cellar :any_skip_relocation
    sha256 "708246ca0d0a053dbd1f2024f3f118a3c2bd5c08109d91c61ae10dbc7a78637e" => :catalina
    sha256 "04e6eae83af9fb6bf8dbf8b334529f269a763350796abcc88589d6d5b48d32f1" => :mojave
    sha256 "f0565923a259c21c34e955c2195d6b8affa9aea43d4ecfea79fc3de0faa2ab07" => :high_sierra
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
