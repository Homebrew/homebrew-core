require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.20.1.tar.gz"
  sha256 "b4a486394648a77f4dc9e2ef0937637524efc4542314c8e0a190eeccd0e67606"
  license "MIT"

  bottle do
    sha256 "8614d3d2c20f0eff5bde826eb69f8161496887ba54db85047f77dac4042cf477" => :big_sur
    sha256 "d0bff90c955d3182c12a3d1871402706e257bbd662004d6021c8964cc03907fe" => :arm64_big_sur
    sha256 "e431fe3deb5392c502c665a3bd9b7d193f3aa42aebc31fa81fed26c117facf62" => :catalina
    sha256 "d63c7815554a36f3f46cf21876093e2f564ed95faa88fa10b79d33d797ee5024" => :mojave
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
