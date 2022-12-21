require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.10.0.tgz"
  sha256 "d54b5d5f40387ac0676b165a559935305b4bf8e78d1a8ea407dfa1aafe04ad10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "787a23e673ac2f63049eab1afb88fd1175a517b55e4121fc0c2d46f34d1b3e18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "787a23e673ac2f63049eab1afb88fd1175a517b55e4121fc0c2d46f34d1b3e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "787a23e673ac2f63049eab1afb88fd1175a517b55e4121fc0c2d46f34d1b3e18"
    sha256 cellar: :any_skip_relocation, ventura:        "0bbd8c06b4d742db511972a20d12dc755bbd31d077aba22fe5b1a7d42c6bc8fb"
    sha256 cellar: :any_skip_relocation, monterey:       "0bbd8c06b4d742db511972a20d12dc755bbd31d077aba22fe5b1a7d42c6bc8fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bbd8c06b4d742db511972a20d12dc755bbd31d077aba22fe5b1a7d42c6bc8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12985d079bc7615485720da4781c50eabc43cbfc5768994dfd7c067045148ced"
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
