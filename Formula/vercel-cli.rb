require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-24.2.1.tgz"
  sha256 "617b31f52991d4e80e3167a9796cd5ebd9e01e4c1518cbb4d802b58e06df3965"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7310273e512d829f2a7e2e5b8a157290da6ed739fad1ba0d5912cabe3f716fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7310273e512d829f2a7e2e5b8a157290da6ed739fad1ba0d5912cabe3f716fe"
    sha256 cellar: :any_skip_relocation, monterey:       "7199b499df301a15af743a889aae863d125f450d2b864dfbc5b5330a5898fdd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7199b499df301a15af743a889aae863d125f450d2b864dfbc5b5330a5898fdd8"
    sha256 cellar: :any_skip_relocation, catalina:       "7199b499df301a15af743a889aae863d125f450d2b864dfbc5b5330a5898fdd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc2ddca16b7128d5510a4f61157137effe1c56639c06677e37ff1a6d3853baa"
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
