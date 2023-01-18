require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.12.7.tgz"
  sha256 "766133747dd62433f188d65ea5baa63cb2af7448fe7698f75b8cc801490621b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b23a7d772bd1950bf19736d1661025269fb2414499487c8d10dfe2d30d5e1bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b23a7d772bd1950bf19736d1661025269fb2414499487c8d10dfe2d30d5e1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b23a7d772bd1950bf19736d1661025269fb2414499487c8d10dfe2d30d5e1bc"
    sha256 cellar: :any_skip_relocation, ventura:        "8a2fcf1f4dbed5ff0dd4c5fb0c9b91fd476dfd1cf4f5201b3e8b2f020f69094e"
    sha256 cellar: :any_skip_relocation, monterey:       "8a2fcf1f4dbed5ff0dd4c5fb0c9b91fd476dfd1cf4f5201b3e8b2f020f69094e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a2fcf1f4dbed5ff0dd4c5fb0c9b91fd476dfd1cf4f5201b3e8b2f020f69094e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "192586f83bbc7e65251e77ec25be434c8b3b9a657447b2d99b2fa73c6af5378c"
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
