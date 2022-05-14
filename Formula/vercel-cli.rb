require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-24.2.3.tgz"
  sha256 "3d6bbe5adbacdd2000b99e6e46765aec1fbb5e7b67037f578803920e8da1ceab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f08a5217a7da49607155289e95e963939ca1c4193c641c72e824d862ec0b00bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f08a5217a7da49607155289e95e963939ca1c4193c641c72e824d862ec0b00bd"
    sha256 cellar: :any_skip_relocation, monterey:       "054802d625019ddefc127ecc5305b3c3469eff40d71faae1da2b9d0848bc8944"
    sha256 cellar: :any_skip_relocation, big_sur:        "054802d625019ddefc127ecc5305b3c3469eff40d71faae1da2b9d0848bc8944"
    sha256 cellar: :any_skip_relocation, catalina:       "054802d625019ddefc127ecc5305b3c3469eff40d71faae1da2b9d0848bc8944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0462e15d63951a075cd8a0cdb7f55d340058b90cf026bb1af7de735c373b164a"
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
