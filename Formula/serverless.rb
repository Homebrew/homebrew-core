require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.71.2.tar.gz"
  sha256 "05400d3f75872d3bfe18a6b029944a6e63ccce33144188ba40ea39fd5df9000e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8468c9d8cebed6517ab16b26d17ecfcb5990e0e2950ab173d94132612dc107a8" => :catalina
    sha256 "75ac75a6370810bedefa7c675aa2feed3bc76b3ce4c5480c795d6b271bcce3d1" => :mojave
    sha256 "19dd29db2caf149a4c4679e8fc7c441ee8a9679f52eaf5209f6e5c7045576f23" => :high_sierra
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
