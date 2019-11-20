require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.58.0.tar.gz"
  sha256 "f94af9b5362ffe6ddb8eb590f054855350110e5542be80214ce329efbb55470b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a57df00a3c804cb6d75b19aa9d356e35124493f36c4dff1b43e1f499a95fc19" => :catalina
    sha256 "3d3d30f4dfe01d600df156e6ebb6de225de8d369af6c259833bb369fe1558e69" => :mojave
    sha256 "48adbbc42c517143e526d7af7e6581bdc5ff9f6745f3cc842e99739c4ed83891" => :high_sierra
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
