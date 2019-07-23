require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.48.3.tar.gz"
  sha256 "c7c4917331186b9b1a19b4db1879e14013b90317540dbf8ebddf4eeab976c5ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "c400376c02eb468505fe9b9bdc78b2169bf76645e06f725bd0dcb49cef575021" => :mojave
    sha256 "73a347497762062e117d771be52f3b312531a41a531e31e1324c8cef83ca2b1b" => :high_sierra
    sha256 "0d664921e737e9b05b6aaab78afde37549ed2a8b6329a8ee1918edaf7382c9e5" => :sierra
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
