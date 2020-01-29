require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.62.0.tar.gz"
  sha256 "782bbf9798e2fabaafa35f6115a3e0fb2e63cf46fd76be5558ee4754c3f7638d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0557c15e49f5ec0e846cec5882851d1b9f51b77946852d439c5198aae8b88af" => :catalina
    sha256 "d3c6ca27c5f67e512e91ec5a48f3dfaea650671dd37bd1c13c9cd59ff5fdcca4" => :mojave
    sha256 "2b10727cf1d402764b1820604cfbe148d127b665445bdc0062a146e2c045ecc8" => :high_sierra
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
