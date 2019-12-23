require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.60.2.tar.gz"
  sha256 "b8793593b87e8511e1594db86e6d1d174796bcb101f047e4070db0959f0b982d"

  bottle do
    cellar :any_skip_relocation
    sha256 "28dfb705ab915d56b8b63530ccac770a530a6a5754c96c6fa11c16a868750782" => :catalina
    sha256 "7764837f2f55d75c5f45fb5cdf7ecb07109c035a6897e6672dbe2a5808143e9e" => :mojave
    sha256 "486a56b9848f527a6d314d0c91cf6eb642f5abcf10c0c2c08b1d99bfc4def1de" => :high_sierra
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
