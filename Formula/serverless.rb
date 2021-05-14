require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.41.2.tar.gz"
  sha256 "bf713876f41aec2ae90115c46958dfe0ddd546c3b5ccda92708528e3ebb79676"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "25f75310c4773d69544b302ff8f946b355b2fe0389177d87b3887517c3287416"
    sha256 big_sur:       "b5809b8ef3cf12548b68a1b3fffec4c6c084c51d836899af1bb0afc2ee6cb5f7"
    sha256 catalina:      "6ab2b6dff8a11fe158a34cdbe47c17bd42dbb3d2e1f64998d8bd508ab5f8c9d2"
    sha256 mojave:        "201c0d47f296d99cb414ba9aaa76e2d4518c2e1f0c22bf87b131c4717659631b"
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
