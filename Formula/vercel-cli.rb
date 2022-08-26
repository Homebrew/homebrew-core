require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.2.0.tgz"
  sha256 "4c725e4942d51cb6de6a6825f3709a74eb62aa59683d84e72a97e4d4e70f3f5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "681f10d1a6edfc23dbcd993c7a4a1400d9d044e24a1d3a00122475cea69bdceb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "681f10d1a6edfc23dbcd993c7a4a1400d9d044e24a1d3a00122475cea69bdceb"
    sha256 cellar: :any_skip_relocation, monterey:       "aba0a875e88c84855f2e8cbcf86753cc7198d8de422e5350847e5845d7a7c0e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "aafeb34c20454553545a54d740852b23f1c7ebb11ebe365ab21b10d0f6b1b6e2"
    sha256 cellar: :any_skip_relocation, catalina:       "aafeb34c20454553545a54d740852b23f1c7ebb11ebe365ab21b10d0f6b1b6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "757ac07b6de4499c9fe4155798d5d229a8bea72cc651358aa662fd72213cdfc2"
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
