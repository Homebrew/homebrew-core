require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-25.1.0.tgz"
  sha256 "6049084e2ceb9bc57cf58a187a870cabb3606e0d1c75fa79483dbe5e5c3f1228"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c680ef75fee524b7345733f94624330fe8ab35d08372c21cb8d0cbf78075b7db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c680ef75fee524b7345733f94624330fe8ab35d08372c21cb8d0cbf78075b7db"
    sha256 cellar: :any_skip_relocation, monterey:       "ee54b5c76454f8c7c0f796be3b6929cfa1c6a54b8e35e8cc00479e8b04baacf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f396e3e5267acac95b1b5f84d07f50953581b67002a3134ece229bc0ec4eb22"
    sha256 cellar: :any_skip_relocation, catalina:       "8f396e3e5267acac95b1b5f84d07f50953581b67002a3134ece229bc0ec4eb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70f576fe5e90696de12a86ab38c2a7213f18688033688e3f2291ca49932f0080"
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
