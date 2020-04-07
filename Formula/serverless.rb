require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.67.1.tar.gz"
  sha256 "f2f99c0ccc04bd3183bc6b05615a79eb5ae2eab5a686113d4e0b2481ba74dfb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "0844bc87c45eab3658592978a007f27a53a0aafc12174d2b231b57806ecef698" => :catalina
    sha256 "1ca1915c74e77515534a172f077f04554b4be56a4f093f871fd07d2c82ec2224" => :mojave
    sha256 "506f5b32407406b906b1b043222f08d9db401c3439d39fc8b97c3ab6037a5adc" => :high_sierra
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
