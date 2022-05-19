require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-24.2.4.tgz"
  sha256 "83db033140b224a499ef23a699ef28df0ff8965bf363c03e822089ce3629cbfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30d1a93faaeb7afa21fd56c3991622577ae313b82a5c45a769a7ca4d074f66f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30d1a93faaeb7afa21fd56c3991622577ae313b82a5c45a769a7ca4d074f66f7"
    sha256 cellar: :any_skip_relocation, monterey:       "483dd51494454e96db2ee5197d42ca52538f3ce0558936aff6edf82f9fb7f706"
    sha256 cellar: :any_skip_relocation, big_sur:        "483dd51494454e96db2ee5197d42ca52538f3ce0558936aff6edf82f9fb7f706"
    sha256 cellar: :any_skip_relocation, catalina:       "483dd51494454e96db2ee5197d42ca52538f3ce0558936aff6edf82f9fb7f706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efea07bb3f61b8f1a0469cd6c475f933a6b4a1e212ff082e64610428dfd61433"
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
