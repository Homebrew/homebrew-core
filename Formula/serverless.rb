require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.79.0.tar.gz"
  sha256 "a14618d9028973438b56a5a5b225e4ba31650da265d3168982837ba4bb6c3bad"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c24df9e4fbcff2261c7fc6b2264d69c63b842cc896b3015163df2ca93204191" => :catalina
    sha256 "e8a15b22d7a42ba2e7587d87d80bf72e414827823216f28c4a38cdbe70d32225" => :mojave
    sha256 "562abbc3220b198dae3521b08fcbf763cab628ff1122b6bef35f797837da4859" => :high_sierra
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

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
