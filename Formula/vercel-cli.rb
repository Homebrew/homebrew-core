require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-25.0.0.tgz"
  sha256 "425899bee7bb7d7c5df16881ec637d725b2298d92010a43f0c1094ba42098865"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88441d4e0c4bdd7bd06eec0d256568c10780c4a920fa0d844e57bcaa5b45bfbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88441d4e0c4bdd7bd06eec0d256568c10780c4a920fa0d844e57bcaa5b45bfbf"
    sha256 cellar: :any_skip_relocation, monterey:       "c07206c5a042d57eb126b43ad08bbecd8a27801633272826c7ce1b3610a06d07"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5c7d881456b980ee8c54f028dc6350811f311d8e1a6850e442a8aa9bfdb7b80"
    sha256 cellar: :any_skip_relocation, catalina:       "59b2c250ea3caa4c3f4ab1f5b74247f8cbc193d6d04aba0a4dee6208923a056c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0c87c057abc6fe494fd4339e5bc3614485bf6f4b801039752cb46e5d5c09ab"
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
