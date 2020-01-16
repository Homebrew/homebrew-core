require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.61.2.tar.gz"
  sha256 "14c42fa84bc60e2051af6a0030dc1377ed0b42c79097b88e77729c1857e0b1be"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab29eb3217d2670f60973c05225e39d46f2132bdf42ab2b5785cc9ac50ff6a4a" => :catalina
    sha256 "dbfeb627cc4b044d01a00296671aadfeb50e5d02ad4aa92eb1e679e46683c2a8" => :mojave
    sha256 "e7d9a70e029d974a79f0ab2c57625a84d2671b94f3fa76a58438d26f0bae3cd4" => :high_sierra
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
