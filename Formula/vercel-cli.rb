require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.13.1.tgz"
  sha256 "00db8070908c89dd150d6f9c53531d8357c4e5b618b52f8278ad4dc0ca4755c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ecdf303225277481ac4c45653916c963b5325c18944a0aa84fd740ca6c19a23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ecdf303225277481ac4c45653916c963b5325c18944a0aa84fd740ca6c19a23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ecdf303225277481ac4c45653916c963b5325c18944a0aa84fd740ca6c19a23"
    sha256 cellar: :any_skip_relocation, ventura:        "b57c14ee8fccbefe81005a36cab0063629fd965ac499d8722f6c2c69a7631bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "b57c14ee8fccbefe81005a36cab0063629fd965ac499d8722f6c2c69a7631bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b57c14ee8fccbefe81005a36cab0063629fd965ac499d8722f6c2c69a7631bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35b59296cdc67e631cf5ca9b81ce161584ccbc5be3b371e6d88d1c81decce41"
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
