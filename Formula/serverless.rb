require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.64.0.tar.gz"
  sha256 "a87a68d6177a262d86abc1417dcaf6f76ea351fbf7ee41b86c7846d6c7f98454"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2523f6da1ef60fabeb05cab18e89c36afc3869206d946962378fbd2572f63ac" => :catalina
    sha256 "7015b8cc32d40bd039db7228c6c2b742ade3cdb9c5a7385b537393c6836a0dd5" => :mojave
    sha256 "35d96ae2573f625d9ab45962cbc2465aeecf4cb29c9f7fc977f80ece0b8b87ad" => :high_sierra
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
