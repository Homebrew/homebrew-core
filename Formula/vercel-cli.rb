require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.0.2.tgz"
  sha256 "a9d22d9cb14f0aed5165fccacb7729b0306b4392576cffe9ac760207964f930a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ee1eeec1eff38ef609f80a923cdb3ebc37856865c81036acc52e6ab9b4a01d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8ee1eeec1eff38ef609f80a923cdb3ebc37856865c81036acc52e6ab9b4a01d"
    sha256 cellar: :any_skip_relocation, monterey:       "af3abcc58fbd7fb070064abbd65639af971fffa0aa91a29a16ac3874ef4965af"
    sha256 cellar: :any_skip_relocation, big_sur:        "62cd9075b14f7f1e9bae515c2174a10678734159b5ef0ef69212e245cc3e988f"
    sha256 cellar: :any_skip_relocation, catalina:       "62cd9075b14f7f1e9bae515c2174a10678734159b5ef0ef69212e245cc3e988f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a17788786ebfcb29af2b275cd628327c6729c949ab5a4d5c5cec03e8dd969b0d"
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
