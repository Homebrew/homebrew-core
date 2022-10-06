require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.7.tgz"
  sha256 "08ac92b2dc20ebe8a113a47d4a46493bd3111dffed18225e5043d7177780c656"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "febc7c4267db532a0fc04bb09af5c57f5d2108215c5e9e048998ac37b0ffcdac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "febc7c4267db532a0fc04bb09af5c57f5d2108215c5e9e048998ac37b0ffcdac"
    sha256 cellar: :any_skip_relocation, monterey:       "51cf4e6dad70ccabda67ff11d61404068ac5a65a332a88e42f66159f1db7a077"
    sha256 cellar: :any_skip_relocation, big_sur:        "11766c0d495917692fb83f01343e038e60b271776b0e48eb8300f02cb2b1d3ab"
    sha256 cellar: :any_skip_relocation, catalina:       "11766c0d495917692fb83f01343e038e60b271776b0e48eb8300f02cb2b1d3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f43bcf97842f820b8c609984e71856bc3cd7e05496cc599e01e542d53fc9d49"
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
