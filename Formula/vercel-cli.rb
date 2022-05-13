require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-24.2.2.tgz"
  sha256 "0953a37414f95972a6b8f530df1441c4b6548a99384389fa54948ccd21d7bd05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada3f45b934c9542669a619b7a8853e81ebdebd63a7dc0164b5d314abef80ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ada3f45b934c9542669a619b7a8853e81ebdebd63a7dc0164b5d314abef80ec5"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1b420782ff1ff96d5d37933098f06c4e0a6b60794d7368fabb959debf5c593"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a1b420782ff1ff96d5d37933098f06c4e0a6b60794d7368fabb959debf5c593"
    sha256 cellar: :any_skip_relocation, catalina:       "2a1b420782ff1ff96d5d37933098f06c4e0a6b60794d7368fabb959debf5c593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ce909f003143072c3d255ac9d680190c5f64e2e07e9724bd4e08380b77ffd6"
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
