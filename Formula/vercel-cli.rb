require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.5.6.tgz"
  sha256 "3faa9b68893a9c6a40e61e59322a9999270f88f32919c62e40cf5de1d9ac8a98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63f6d92a99900a084eb4aa1b7486508b3ee1bff9da9b37364c95d3fe62b73c38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63f6d92a99900a084eb4aa1b7486508b3ee1bff9da9b37364c95d3fe62b73c38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63f6d92a99900a084eb4aa1b7486508b3ee1bff9da9b37364c95d3fe62b73c38"
    sha256 cellar: :any_skip_relocation, monterey:       "7b34de471021d09e469ce94c98ed601d5a3bbcbe3a1b4a3c8b424861d80371c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b34de471021d09e469ce94c98ed601d5a3bbcbe3a1b4a3c8b424861d80371c4"
    sha256 cellar: :any_skip_relocation, catalina:       "7b34de471021d09e469ce94c98ed601d5a3bbcbe3a1b4a3c8b424861d80371c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee34e523518a7b441de004bb3a71690f01514f2df79c86d98d1488d7f6af43ec"
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
