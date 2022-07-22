require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.2.0.tgz"
  sha256 "37826adcef81e6afbcee3a0795d8d305d9cb974ed19407e5e3cee5ac8ec3e928"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01006db23a5b4ef1f87f7d533fc74086cefc9cf8576d3a046d3eeaac7bd8b303"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01006db23a5b4ef1f87f7d533fc74086cefc9cf8576d3a046d3eeaac7bd8b303"
    sha256 cellar: :any_skip_relocation, monterey:       "e56374811a940dc60df2f0e3c0134c2cdf2be2f5bb67496dd3f94d111146ed79"
    sha256 cellar: :any_skip_relocation, big_sur:        "76355482f7482445496c2eb9f4422273e228f79ef22f2e7d3d6e674cf84baca0"
    sha256 cellar: :any_skip_relocation, catalina:       "76355482f7482445496c2eb9f4422273e228f79ef22f2e7d3d6e674cf84baca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb48521e6991b5789c482a0c453b6c96168728ca7ec990df1975511ae959ae83"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
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
