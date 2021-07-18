require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.52.0.tar.gz"
  sha256 "bdb7653a0d2db7129cf99700b9c9e51365dd63107b39b5a784803473764d48bf"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "a2957dbac36a5dedd73f6dbdc9f37ae5d6cc3f78fb21aa6e9e59db4e9e1ba82d"
    sha256 big_sur:       "5a091549938e52a6a38098183e19ff6907d8ad0c64b22c2e49ba4a3b2ceb7791"
    sha256 catalina:      "c3306335eafec524272e9fc5f2d4074d7a9590ab5efff1fce8def83d6a8f8d58"
    sha256 mojave:        "040913df137130ee781ee54c1b535ec331fdfd74d91c539739b42ce291c0dfb2"
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
