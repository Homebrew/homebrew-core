require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-23.1.2.tgz"
  sha256 "4d70d24cd61c69e7925c44119516b57ec3614815cb9e7ad95d15e2e5297f3fff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "848563a59a3857fd0256b96539e62f330c984c99819ce4a2b53920190f75bf3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d29c72ee982f0570268925aa018ed305602ee7852374ac1ae0da2ccfc72153e0"
    sha256 cellar: :any_skip_relocation, monterey:       "a608016fe7bb15dc8f2da6a7ddd484ea60355ac3061bc719fdaa4c21c00d01ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f43661170b3cb218a03326790a654d97abcbf7a4cfcd344f9286a095bf023ec"
    sha256 cellar: :any_skip_relocation, catalina:       "7f43661170b3cb218a03326790a654d97abcbf7a4cfcd344f9286a095bf023ec"
    sha256 cellar: :any_skip_relocation, mojave:         "7f43661170b3cb218a03326790a654d97abcbf7a4cfcd344f9286a095bf023ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06b886f8dec030c4ed906a86d642343eba7629626487742f8bc8d5632fabfc8e"
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

    term_size_vendor_dir = libexec/"lib/node_modules/vercel/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    dist_dir = libexec/"lib/node_modules/vercel/dist"
    rm_rf dist_dir/"term-size"

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(dist_dir), dist_dir
    end
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
