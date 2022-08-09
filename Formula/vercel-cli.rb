require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.3.8.tgz"
  sha256 "f567dd1f4183de626638303abe0e16fba57a127ae2385624b7a88ef77f9271f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffd667f2075b995c612b28fa44d5e7bc140b7685fc11b36d92fe2cb36a4983a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffd667f2075b995c612b28fa44d5e7bc140b7685fc11b36d92fe2cb36a4983a6"
    sha256 cellar: :any_skip_relocation, monterey:       "21fb90463a407cfed480a8c34534ebe48f31103d12193f8f62930c108fa08fb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "941dc6e2647eea2e34957006bdb9abc1aee8d261c12f4d27354196c31c7a5481"
    sha256 cellar: :any_skip_relocation, catalina:       "941dc6e2647eea2e34957006bdb9abc1aee8d261c12f4d27354196c31c7a5481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb6bdc83707f01a3edf1eaed470f8265fd72fe273fb54dda951e4fe86c2b190"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
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
