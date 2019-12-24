require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.60.4.tar.gz"
  sha256 "edc21e81c2d50b05591f0ea32701e475366f2a2455df9afda9a1101c89a5b624"

  bottle do
    cellar :any_skip_relocation
    sha256 "581a0d8350f681fa5622532c760171d57bf84c4ab0bbc53539a224b20b7c013b" => :catalina
    sha256 "4d38458e7a04fa3cf0e92bf9f07c6c63e0455f4254f0c388ba7e3eac381d634d" => :mojave
    sha256 "2d12a3fb89f9dde9bce29ce4130bf21c5da3571d42454a4b690ab82fb8b30aaa" => :high_sierra
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
