require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.1.3.tgz"
  sha256 "1b90980c8d4ae155d4c23ce99d00c21647f82fc96ad7bda906b981805e64619b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "460a89c171effe5fc4a3e7f1e4210653873b979e4a2e288392b98e8ec8f1bf48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "460a89c171effe5fc4a3e7f1e4210653873b979e4a2e288392b98e8ec8f1bf48"
    sha256 cellar: :any_skip_relocation, monterey:       "938f4341c4921dc03f77e8dca802c7bd1644f3d94540e9bfd163673ea292c654"
    sha256 cellar: :any_skip_relocation, big_sur:        "df2f4f86e20fe1cfc197f0cc8990e0f5388aa8c434cc60fabac2cc6b3b0dceb1"
    sha256 cellar: :any_skip_relocation, catalina:       "df2f4f86e20fe1cfc197f0cc8990e0f5388aa8c434cc60fabac2cc6b3b0dceb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1725016237fdd5f0c883e43a406c37f0f401810202d940273ee6cd8f7b2ee565"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    dist_dir = libexec/"lib/node_modules/vercel/dist"
    rm_rf dist_dir/"term-size"

    if OS.mac?
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(dist_dir), dist_dir
    end
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
