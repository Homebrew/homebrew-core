require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.60.0.tar.gz"
  sha256 "023f826a77bea33fc65463000a3bd25230576350d99c58c321d475e85f4dbec9"

  bottle do
    cellar :any_skip_relocation
    sha256 "70e9c34273d3a2672af23737534b3ed40882fb1c5ca018a06dedfa135cbcb239" => :catalina
    sha256 "2ed5df5693de7f73be294b09baecf1f2a82694db68fd9d9a513d64e59936c038" => :mojave
    sha256 "4998370cb78c220b805741ca3767b584783947c0ae33a249b714bbec34ba2c8c" => :high_sierra
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
