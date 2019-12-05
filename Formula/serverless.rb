require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.59.1.tar.gz"
  sha256 "008bfa1d2eb67d80d1e248f2f6dc625d520652d15bf09fdaab0923c7a522c6c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "28caa9feeb2594ac2f7ee3d71f23611b055236a62a18b2ec6607376c74ee9e04" => :catalina
    sha256 "80725405a3a19289ae443258a0450f305d67b4d883926f950f862495f36618cf" => :mojave
    sha256 "03d87551e0b7a8d8df8d659a43f5ce06ec5238beda9805fd03e541cabf733755" => :high_sierra
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
