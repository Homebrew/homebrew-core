require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.42.2.tar.gz"
  sha256 "59f9a4dd36281addf163366f192ed6199a00cbbee96527ee47e91c8bef688c79"

  bottle do
    cellar :any_skip_relocation
    sha256 "97885f316266948c830f218e99260457427de0bd6f2f8208b110a673dbdc0883" => :mojave
    sha256 "9586bffb00fefe95b7827d86bbe084e2e65da9c6908a57cd0a2585bdd315a8c5" => :high_sierra
    sha256 "0f89e059d344dd9e127476b988545675ef342073513806b2738729447ca1d06d" => :sierra
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
