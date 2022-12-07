require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.8.0.tgz"
  sha256 "34c78ebb87a472f38f0f28b8a92d067b52abe8dfc24f30401f890fa6291786ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f657af9125138b1cfac5f0bc631906dfb4d4161a775099c655fd92fd20b7fd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f657af9125138b1cfac5f0bc631906dfb4d4161a775099c655fd92fd20b7fd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f657af9125138b1cfac5f0bc631906dfb4d4161a775099c655fd92fd20b7fd1"
    sha256 cellar: :any_skip_relocation, ventura:        "c6898f20015407ea4ed0ee429b9bc66fe0fff7eb986374195a683fb1ed97889a"
    sha256 cellar: :any_skip_relocation, monterey:       "c6898f20015407ea4ed0ee429b9bc66fe0fff7eb986374195a683fb1ed97889a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6898f20015407ea4ed0ee429b9bc66fe0fff7eb986374195a683fb1ed97889a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54af054dee95a102d7c7458773459363df82f65862f070d69da92a6667d56b14"
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
