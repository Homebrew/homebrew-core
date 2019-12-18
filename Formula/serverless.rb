require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.60.0.tar.gz"
  sha256 "023f826a77bea33fc65463000a3bd25230576350d99c58c321d475e85f4dbec9"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d0b0edc1a820c462a4fb2e48fa6771996d6b79b3ef68a12cf59a805ffe98648" => :catalina
    sha256 "3030d43e2594de836763d252a3baf98435d45af9c865278e51966307887299bc" => :mojave
    sha256 "abddbdd43cf89f6c1baa31d5b777343901ffe0acf6efc163296ac4e005c28421" => :high_sierra
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
