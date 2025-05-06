class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-6.3.5.tgz"
  sha256 "083dfbda7d984ea8884c23fc4e9778a0ef647442ecffb599026109d578753c0e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a11cb80ae2e244ddbde6bd6eb09781c99a7cd492953f23c8fac7461195d85044"
    sha256 cellar: :any,                 arm64_sonoma:  "a11cb80ae2e244ddbde6bd6eb09781c99a7cd492953f23c8fac7461195d85044"
    sha256 cellar: :any,                 arm64_ventura: "a11cb80ae2e244ddbde6bd6eb09781c99a7cd492953f23c8fac7461195d85044"
    sha256 cellar: :any,                 sonoma:        "2c9de8123361b9f1d4ea9c50ec3c31224442194c0a7058c1eae2b6fe8cac41bb"
    sha256 cellar: :any,                 ventura:       "2c9de8123361b9f1d4ea9c50ec3c31224442194c0a7058c1eae2b6fe8cac41bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dc665f1110f8b2ea6f79830374b943993974f64c5a8b4cf1cc35ae01a9563b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc844708551ab9e69eb2a759c49624e1cf9f1435656b36f876a0d09e47e2feb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
