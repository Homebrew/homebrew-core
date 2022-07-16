require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.1.5.tgz"
  sha256 "1859adfdbb231f2db8ad883d0018e837c1cc622573dd43397d9ff28af7bd2bd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe8dc1034355ce961a65a3e117165548a207f819b5846a361d2374c66ba9c4df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe8dc1034355ce961a65a3e117165548a207f819b5846a361d2374c66ba9c4df"
    sha256 cellar: :any_skip_relocation, monterey:       "f4e4831fb6f25647dc2de34b9dcdeeb264993b59ca9009981ecbc1e16972848d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b53e378b1d66e2bd8809fafb65422013d0cd1b0435cfa875a567105d468b4872"
    sha256 cellar: :any_skip_relocation, catalina:       "b53e378b1d66e2bd8809fafb65422013d0cd1b0435cfa875a567105d468b4872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9004b4ec816ee6815dd23565ddb2a92f594b8f7b5d956bfb36a9f1d0abd0ea"
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
