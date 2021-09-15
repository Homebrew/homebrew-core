require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.57.0.tar.gz"
  sha256 "80a4ce6a737a58fb23cc5095f14e2a147f72b7607b48c28709f085467f9377d1"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "be114aa3dc7ed36e15b8ca08e7762ab44509b6ce23535e85d5cfa5e5f97fbd7f"
    sha256 big_sur:       "6b3cef14d0bc829f88b82d650b9e10132f64405ac2336a0391e8bda4e3e3347e"
    sha256 catalina:      "540e3d76b4908e3c074a30433a338e18f104601e4a0726cad5379172520e42d6"
    sha256 mojave:        "c247563d91a332423277e1347f7ac27638e95f4c5921465a02b2a79679f33075"
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

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
