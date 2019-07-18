require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.48.0.tar.gz"
  sha256 "ecf0a36c6e5bca6ce26da67fb31d613cb4179817cf47e50bdc231963c5b5ec9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "648ef404cb9f41164b10d515c8865c7f1dfae136714c8c1028a19bed1379375f" => :mojave
    sha256 "e49c836ac3820b62a86b2f4224f2c4cc00fd7e088591b2c89200dc3a93bf07bf" => :high_sierra
    sha256 "e68284093ba4dbe97204fd99440dd24e3f2891b8092fadc4c523883c2b09b794" => :sierra
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
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
