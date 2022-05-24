require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-24.2.4.tgz"
  sha256 "83db033140b224a499ef23a699ef28df0ff8965bf363c03e822089ce3629cbfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8dd5d26b235e360a040e64dcd926c25e8f982cc6de1db07e4bc5b553f6225b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8dd5d26b235e360a040e64dcd926c25e8f982cc6de1db07e4bc5b553f6225b"
    sha256 cellar: :any_skip_relocation, monterey:       "481fd2e12ad26548cba89fdbe6a97814b7f2798962d1fcfafbb6df1953d83710"
    sha256 cellar: :any_skip_relocation, big_sur:        "481fd2e12ad26548cba89fdbe6a97814b7f2798962d1fcfafbb6df1953d83710"
    sha256 cellar: :any_skip_relocation, catalina:       "481fd2e12ad26548cba89fdbe6a97814b7f2798962d1fcfafbb6df1953d83710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251e43de54ff181b2dcc1917c901dd8b0ccd92dfa41ba20b2780126d609d12fa"
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
