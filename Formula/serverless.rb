require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.41.1.tar.gz"
  sha256 "c65fe64fb84dfc63897a748de1d25ca7bfb60bc347c67c254ad2d60b70eccc4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f0ee28e5c27e2f74281a464d36e5527cfc401a6d23bdc0a6b5d674507ca3bc2" => :mojave
    sha256 "de1842461df724b6cce8b1457bc63e770e46ff263fde3b32f010ab81fbf06774" => :high_sierra
    sha256 "efa59b5ef216361f1eee621729a15e62f410296e54a405f80db17481fa28f1a5" => :sierra
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
