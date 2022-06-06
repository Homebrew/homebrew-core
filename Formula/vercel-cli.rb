require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-25.0.1.tgz"
  sha256 "510089d8c235505b6217e104d15900bd55039d93dd57635b0f760bc19ccf243a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d3dc191076bf9fa3b782003ac2f6f209134373978d8c6fe38e1e8a4fa505b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4d3dc191076bf9fa3b782003ac2f6f209134373978d8c6fe38e1e8a4fa505b6"
    sha256 cellar: :any_skip_relocation, monterey:       "518c3a4729c66a49a69340c1960e52856f34413b2cc7e828bd48ce71eec1bb10"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e229847008356b483953f6735498690d0f8f477b95c00984ca331c0bea384ec"
    sha256 cellar: :any_skip_relocation, catalina:       "0e229847008356b483953f6735498690d0f8f477b95c00984ca331c0bea384ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b733bfb76668bc07f76ec05f8f58324d574eff2273d51d47e89764651c4996"
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
