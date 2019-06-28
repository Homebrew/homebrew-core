require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.46.1.tar.gz"
  sha256 "308191f8819fc65e42a8543f0f273014d3a62f2d4645d1621e418b97b698ade7"

  bottle do
    cellar :any_skip_relocation
    sha256 "13fc1b47e2537945d417c4aeec55f82626a1f96c3a0de49ef34ebcbe02036cab" => :mojave
    sha256 "67fe8a3750316d56ca454f689053bb6a42a28dc9205dbb5e3995d4a10ebe5212" => :high_sierra
    sha256 "fb59f499e79d440f04fc970ba1a1d3081624d6f9c4edd7c106f28d0b6fb58d47" => :sierra
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
