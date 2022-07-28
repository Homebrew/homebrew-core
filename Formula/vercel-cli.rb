require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.3.0.tgz"
  sha256 "9d03bafee64ba5554284b84b52c3f838dcccd7c4be41a89162d0ca9569e00b13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0323e70e9c914d62cd1baa74e11b022829f7fbe50db773fa667384343fa1eb9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0323e70e9c914d62cd1baa74e11b022829f7fbe50db773fa667384343fa1eb9d"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cc7b4d2fd7fe9360421de555dfdf994d1f9f5c3ce27371e15fbcf9ffffa6c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b01d0750f74f40add110791d14a8594b4a8162833225d15ee69cc066b6e59cf"
    sha256 cellar: :any_skip_relocation, catalina:       "0b01d0750f74f40add110791d14a8594b4a8162833225d15ee69cc066b6e59cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "390eda087eefea5130e9cbaddbb7b69dc1450524f8dab7684892e26c8d183620"
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
