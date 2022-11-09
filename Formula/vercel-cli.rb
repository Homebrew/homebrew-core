require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.17.tgz"
  sha256 "8264a930839059be26cbe2d01ba44c4553c55af0578018dfa8ff7c0f61d79d60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a00e39ae3c755946fe6a0733652cb17b2a49655afed4a2b545787804033f4d9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a00e39ae3c755946fe6a0733652cb17b2a49655afed4a2b545787804033f4d9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a00e39ae3c755946fe6a0733652cb17b2a49655afed4a2b545787804033f4d9e"
    sha256 cellar: :any_skip_relocation, monterey:       "1b0e46099dfc1831d8bdea30d425f56181ae62269baf9097bd57c2b0fdc819c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b0e46099dfc1831d8bdea30d425f56181ae62269baf9097bd57c2b0fdc819c7"
    sha256 cellar: :any_skip_relocation, catalina:       "1b0e46099dfc1831d8bdea30d425f56181ae62269baf9097bd57c2b0fdc819c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38a5afd39f98ebf444aa768019132659ff034bbfc43f4ba7530be550a86cfe90"
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
