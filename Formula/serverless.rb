require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.54.0.tar.gz"
  sha256 "23f3c8764d1136e4e2fdd44edd81e48f7d8325236f36567a7ddf6c57b5263195"

  bottle do
    cellar :any_skip_relocation
    sha256 "b979db02c0ce4ce1a33729d53e58b161c4627b39e6d95ab6136afac800e103ef" => :catalina
    sha256 "fab6116bc58cbcc41f19eab6606a9ea83366a663ae3b3e1d1219de290b663c9d" => :mojave
    sha256 "9081a4b7ccb6b571ce659f109de6de1c287f7c6612b4f8f735132c18a51ec8fa" => :high_sierra
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
