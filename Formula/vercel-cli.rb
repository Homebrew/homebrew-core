require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-23.1.2.tgz"
  sha256 "4d70d24cd61c69e7925c44119516b57ec3614815cb9e7ad95d15e2e5297f3fff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ce3c16852a1b9c1a9984a00a6ce5d98fafacc016e2d11ee7e92fc66c22c0c59"
    sha256 cellar: :any_skip_relocation, big_sur:       "13902314ab6290c74040ef95eb8a6fdfc54b7b6922a1ed990c6a78cf80115b6e"
    sha256 cellar: :any_skip_relocation, catalina:      "13902314ab6290c74040ef95eb8a6fdfc54b7b6922a1ed990c6a78cf80115b6e"
    sha256 cellar: :any_skip_relocation, mojave:        "13902314ab6290c74040ef95eb8a6fdfc54b7b6922a1ed990c6a78cf80115b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25fc063700e5677f469016bb7f2df38669ac9e898237e09515597067f54be884"
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

    on_macos do
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
