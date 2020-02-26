require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.64.1.tar.gz"
  sha256 "4a1bd2aefe071dca199c31567f5324303ed52fc21a91625dcba1c346233edc74"

  bottle do
    cellar :any_skip_relocation
    sha256 "46d80554deb77d8c5878a49b3126bac3602e76bc8e9fc2e85e4a13a5ba7bba70" => :catalina
    sha256 "ccbdf203d0019afe0b300cd639b20f59d9badbdfc02e16a86ce67812cff9d47d" => :mojave
    sha256 "a6334e465f92030562ab9f50e75e0e51ab50ae451a28bf0effccb7b770f740bf" => :high_sierra
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
