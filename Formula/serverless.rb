require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.1.0.tar.gz"
  sha256 "f28ccd3c70b28e641c2f50a90f032df2bd035b043d891e5a0052a78f107057d9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1ddca4a669e569f107f5ae6d768f764738d1389eaebd1f6292e894236261ac5" => :catalina
    sha256 "d5c9b217e5b89c3691bfcaa1dfdefe8d53781ef5480f4d89c33e6f89b9d9e807" => :mojave
    sha256 "4d47a09d39097c2bd43678f3dc880799dcbe4a8256afcc4407edaf982bf06da4" => :high_sierra
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
