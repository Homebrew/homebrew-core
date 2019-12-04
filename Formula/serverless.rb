require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.59.0.tar.gz"
  sha256 "b239818648e42bf42fb05fd859cc7c8d8bf3e60270c5051da73cecd0b10c7340"

  bottle do
    cellar :any_skip_relocation
    sha256 "95a21b2a415286572c274f05c7e7b56176f907c2b91e156352743c6d997f5a7f" => :catalina
    sha256 "6f6a45e7b8d43d6f8ff711e5203c9e55026dcb016f5c3fb7c11a8680facb29fe" => :mojave
    sha256 "bf84a7fb4ade04c02d1a5d8c09c9c3db193e9cf31474cdf7a77570b00f0980f3" => :high_sierra
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
