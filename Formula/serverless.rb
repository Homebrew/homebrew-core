require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.67.3.tar.gz"
  sha256 "29905355428e417cdfcfd1c4dc1d5bc36f5ff42f06b5ae95411fa42d21b473a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "65d4e620568d7b4b8c84897048acc54930d4adee7fa85dee4f5a2c6653426dca" => :catalina
    sha256 "c1f7be30bae251c1e967fe740b6393519437b6e11580781ecb34f86a0fe15044" => :mojave
    sha256 "42b9044da11e5f7b883c6e43a2cc9060d3a86bbbf0f7650b7c414564d834b543" => :high_sierra
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
