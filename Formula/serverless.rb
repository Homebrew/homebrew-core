require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.50.1.tar.gz"
  sha256 "9aacc997b6d1b82191e83c9ab53be04edb5ad81da4bceca257a6a7e2e462729c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b040bef663ea655345552d1bc179ec36422a0bbd07b19e7bb41eef4039e025ab" => :mojave
    sha256 "592767e884692dc326bd0464c051c2d934364e6a956b5d2c8ab86542d7f566c8" => :high_sierra
    sha256 "3e0f8cc07b0d99466d45266fcfc2840ca4d6315b9c8d9503bb79f17fe51e850e" => :sierra
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
