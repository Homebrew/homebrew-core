require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.1.3.tgz"
  sha256 "81c68a2dc50f9100b6bf6979f5e6d3186859a53720c9216b1b96936ea2b3db09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06c7ae11caeb1ca3ca204398840069fc8157fe2fdc14769edc5ddb37cc83e6ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06c7ae11caeb1ca3ca204398840069fc8157fe2fdc14769edc5ddb37cc83e6ee"
    sha256 cellar: :any_skip_relocation, monterey:       "bf9be307dfbbc7b0666f60e0092bd8be1c264a83aee519e2d65b1a11e835ebda"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2bb023404347e0a1dc464937c87b881e684df9149207390f34efa3de9b629a3"
    sha256 cellar: :any_skip_relocation, catalina:       "d2bb023404347e0a1dc464937c87b881e684df9149207390f34efa3de9b629a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7bb0fb76c71d6c4d720feb06d1358dd6015d14b033a812373b7282dc3434893"
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
