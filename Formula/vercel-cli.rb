require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.15.0.tgz"
  sha256 "b750003791fae7f8f35a500912ee716df70c9a9479576ce0b91cd80f2920350c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ff96983b9cea379df4ec009210b21ccd23d84505438f3b47a8c9c35df153119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ff96983b9cea379df4ec009210b21ccd23d84505438f3b47a8c9c35df153119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ff96983b9cea379df4ec009210b21ccd23d84505438f3b47a8c9c35df153119"
    sha256 cellar: :any_skip_relocation, ventura:        "6ac998c31a1d3d329a78d24df423ffc8edd1dd4983954a123acc010e75210147"
    sha256 cellar: :any_skip_relocation, monterey:       "6ac998c31a1d3d329a78d24df423ffc8edd1dd4983954a123acc010e75210147"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ac998c31a1d3d329a78d24df423ffc8edd1dd4983954a123acc010e75210147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "430c7564015d971fb431d68876c682f2c47223564f871eca58bc82fa1f5b72a5"
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
