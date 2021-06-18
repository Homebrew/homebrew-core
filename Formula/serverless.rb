require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.47.0.tar.gz"
  sha256 "9c7be3b04d575ab90d69cdf7296f02bf48a599d17a865cd6c46c3ce17176e509"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "49718149e5435cd472520b8e56fd76ede16679887823303bb3466c07e31e0282"
    sha256 big_sur:       "4c25afa87af505d76c2ca8ffc143dbd07d2b28c91fd91b3660e3f5db863f1389"
    sha256 catalina:      "16b08c8b7b00f56e6cf56726a05a064e310cd68f0a522ee8599627fa6e8b17bc"
    sha256 mojave:        "1e760446a4c03289f5cce7b92ee8e3c7b93c9f26cbbdb575b6b095802d35d80f"
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
