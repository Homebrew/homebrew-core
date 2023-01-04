require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.10.2.tgz"
  sha256 "2892d60e666db49e4c9936b94b16b52f922eaaa14e6c66d48ad922f357d874fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5aa45f6d2ce540beda0b53827a854b50dd732dec65131cee429d378d9d7f9e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5aa45f6d2ce540beda0b53827a854b50dd732dec65131cee429d378d9d7f9e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5aa45f6d2ce540beda0b53827a854b50dd732dec65131cee429d378d9d7f9e8"
    sha256 cellar: :any_skip_relocation, ventura:        "9a383a3843ba31a099c1c63f1599ca105e2a967ce30b59b5485a27a928195023"
    sha256 cellar: :any_skip_relocation, monterey:       "9a383a3843ba31a099c1c63f1599ca105e2a967ce30b59b5485a27a928195023"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a383a3843ba31a099c1c63f1599ca105e2a967ce30b59b5485a27a928195023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b34cd27ed09a5aa87c7bd8a87fe00ae3e77e56984498aecdd8464d3c75342c"
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
