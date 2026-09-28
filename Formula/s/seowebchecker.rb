class Seowebchecker < Formula
  desc "Lightweight website SEO audit tool and CLI by SEOWebChecker"
  homepage "https://seowebchecker.com/"
  url "https://registry.npmjs.org/seowebchecker-seoaudit-sdk/-/seowebchecker-seoaudit-sdk-1.0.1.tgz"
  sha256 "1f7844c86c6287fcaa7a149508f353deea5d3cdf24b8778704fa784e1d1f2c51"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/seowebchecker-seoaudit-sdk/latest"
    regex(/["']version["']:\s*["']([^"']+)["']/i)
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bin.install_symlink "#{libexec}/bin/seowebchecker-audit" => "seowebchecker"
  end

  test do
    assert_match "seowebchecker-seoaudit-sdk", shell_output("#{bin}/seowebchecker-audit --version")
    assert_match "seowebchecker-seoaudit-sdk", shell_output("#{bin}/seowebchecker --version")
  end
end
