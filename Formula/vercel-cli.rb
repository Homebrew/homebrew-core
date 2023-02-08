require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.15.2.tgz"
  sha256 "3261cb771bd4dd34b5f7900c8190fb524a1a5265ac876719807eacf47515f5c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "908aa8c41ef474c650cc20f5ad4413288f7006b17e4bf2b022c66319a2c78c15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "908aa8c41ef474c650cc20f5ad4413288f7006b17e4bf2b022c66319a2c78c15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "908aa8c41ef474c650cc20f5ad4413288f7006b17e4bf2b022c66319a2c78c15"
    sha256 cellar: :any_skip_relocation, ventura:        "3c43874708dda3743291f2c84cde478259b3a7217776261856f523a5a6b24605"
    sha256 cellar: :any_skip_relocation, monterey:       "3c43874708dda3743291f2c84cde478259b3a7217776261856f523a5a6b24605"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c43874708dda3743291f2c84cde478259b3a7217776261856f523a5a6b24605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6986ea9241584484c2a76aa206cd83d7c0948d3155ea00ed0dbd3b1b7fd3330f"
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
