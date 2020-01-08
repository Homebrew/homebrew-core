require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.60.5.tar.gz"
  sha256 "22e98bbaa6b8ea96ce237f51f2d5319f9258fbee8b2ea6593a5cda20d44de2e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6f6ec879195479c078c6afd85baf484d1fe9d6a9debdafd6f65bcf36f5d6110" => :catalina
    sha256 "e1e3e2aa4c0083ae38cd733684623f05a40d96b283018401f93eaafe0346aa4b" => :mojave
    sha256 "def4440d7d2a1933d5dc0db18caff3a701c3fa14ba98cd49c9c2222665772670" => :high_sierra
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
