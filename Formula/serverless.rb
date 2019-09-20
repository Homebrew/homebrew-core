require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.52.2.tar.gz"
  sha256 "7f08b4f48421a40f43535c1656d78a5776fdc5aecb9f6395ce639ea9ecc9d9c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "62bf07cef000c84557e8cd9b7daa51ae086880dc07d2478c6ec36b62bd82a6fd" => :mojave
    sha256 "1d3cc177af94eb5cb6053440e6d9de073a1b3b04913969d62cd8f5308eca04e4" => :high_sierra
    sha256 "36be924ec5e3bf097710c539abdc372092d4595d11d4b0cbc76e8730248c14e1" => :sierra
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
