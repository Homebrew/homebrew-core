require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.55.1.tar.gz"
  sha256 "d36750aa88b67c625fa53a1fa72ff61da347a0edc851a231be121dd934607d66"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea99dbe4593319ba34fffb09d01e3db2a174faff56b32bbc6b6ea66f8ee30a6e" => :catalina
    sha256 "c33e3f12a7d63a67fcbfbdecd882ce4d64a4fc05e02165ef6685621957ad75dd" => :mojave
    sha256 "ff2bace1d6e515fc3ea77901e498565422f999e3417ec2648194a781e0c223ae" => :high_sierra
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
