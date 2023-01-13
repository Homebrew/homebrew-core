require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.11.1.tgz"
  sha256 "7a7a2baf61f9a14b655bc0ff7fb74f54c2a53e6edc2da9fd0d306f246d53f373"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e72d09032b3228b8c09f8d2d0c7933b58fd1894d9bd01f54b4f11a0ad4a7564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e72d09032b3228b8c09f8d2d0c7933b58fd1894d9bd01f54b4f11a0ad4a7564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e72d09032b3228b8c09f8d2d0c7933b58fd1894d9bd01f54b4f11a0ad4a7564"
    sha256 cellar: :any_skip_relocation, ventura:        "974bf3898db422c4419081817bddc39fd6c6586935736f0c5757c15265fa79e9"
    sha256 cellar: :any_skip_relocation, monterey:       "974bf3898db422c4419081817bddc39fd6c6586935736f0c5757c15265fa79e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "974bf3898db422c4419081817bddc39fd6c6586935736f0c5757c15265fa79e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be123af783b5a10d7140f0219176afaf66751be6c623cb4d61392b4d67f0a6d5"
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
