require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.67.3.tar.gz"
  sha256 "29905355428e417cdfcfd1c4dc1d5bc36f5ff42f06b5ae95411fa42d21b473a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "682b964e3cd5074e9214a4a1fb65858f246e25eecb95de45d87ff76b51990fdf" => :catalina
    sha256 "4fd085e796f3b57286d0ba15f04bf164a8959ddb5b98a9ede7dcd0f4eef0efb6" => :mojave
    sha256 "e14a514b8ae5115a70cfb1961e486bea6403840257ebe9fe4788e61005fdc53b" => :high_sierra
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
