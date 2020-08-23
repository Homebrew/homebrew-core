require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.79.0.tar.gz"
  sha256 "a14618d9028973438b56a5a5b225e4ba31650da265d3168982837ba4bb6c3bad"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "57e6fe41d3091d4d5a7e5dcaa75e42f71b0e19f0c0445e89b6cc61de555f9386" => :catalina
    sha256 "ea48fa5522ac50bac6127ccf8380ab93ff79a126c32dae8bd0cace8868c8613b" => :mojave
    sha256 "cfb894eb28cda0b121c75475f423d68b36a755ba6ee0268da3144c32e961584f" => :high_sierra
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
