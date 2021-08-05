require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.53.0.tar.gz"
  sha256 "736f6a1fad05f18bd3e40adc2b1b62965e294f6b62bbd25f41c415025aa8dfe4"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "2fa66cafc0eb46ef5bfa1b3c82fa86d1c8b36d780a2fe714e02c28ac01916eab"
    sha256 big_sur:       "9108e78d1ca5e41fd07421f5533a532e8c3dc89351e4b45f033faf4d2da28b37"
    sha256 catalina:      "c802985e52c1fca57c1d2fe05a2e110c99ea8723be823574b75435e6231bac7c"
    sha256 mojave:        "7d95fbc770bcb421751b576902bff7f1c68761d2fc4f10d426df363d8b0ec38e"
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
