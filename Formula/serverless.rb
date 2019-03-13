require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://registry.npmjs.org/serverless/-/serverless-1.38.0.tgz"
  sha256 "bb17098cc2d1e58965908eeff2c3c914260fcdd2ee3cb80ec3863b4ace29825f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c364867dc80cb32d9bdae37fa6220ecc79905f69d9efb2f3d4b819043aba9a6" => :mojave
    sha256 "2953cebf4c420a3ac6f69ce6f8347145a2197e26693faf0c8f06408cb08efcb0" => :high_sierra
    sha256 "a5e501ef0a59876b6d1834204cb9458c8c6e05060d509b9d35dc8e44ae16ddea" => :sierra
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
