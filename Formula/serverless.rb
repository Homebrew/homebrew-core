require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://registry.npmjs.org/serverless/-/serverless-1.33.1.tgz"
  sha256 "bc148ae6c6bf23124df9806f56b0772cda8c19c7d8c7224868d4d5163d640f34"

  bottle do
    cellar :any_skip_relocation
    sha256 "85c8ca2b6725105b84b37e1477fdd6e824d8dc0c31433ec3ccbf589a8aa9febd" => :mojave
    sha256 "e1d39ab6b8444524adb4b7e4a8a927522f0739fcc2c20f60f3a41a29a90cedad" => :high_sierra
    sha256 "b6e661570b2937b9d079767cdcabc2cf4eeeb45ca456f8a640f0a0936e0e593e" => :sierra
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
