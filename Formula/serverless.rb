require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.61.3.tar.gz"
  sha256 "ccea309af3665875087c39d7cb9d48d2033e711d17d41fb9d8218b453a5c6b83"

  bottle do
    cellar :any_skip_relocation
    sha256 "c24bff65d4bb42bea05430a26632ee21c0dcdc5d7d513f379c95fd6d38579299" => :catalina
    sha256 "5965728f6412c4f637e591360de4714186bdd61ab0bf7738cf44ff34dfc0f676" => :mojave
    sha256 "a6a7df07f83ee38fe0a5361bce6725a7411a1a51277fad34c532cc3661b93047" => :high_sierra
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
