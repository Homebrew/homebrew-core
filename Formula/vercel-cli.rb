require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.12.8.tgz"
  sha256 "7d43354aa759fa713d1e69eae22ab020441a549de9063502ec8981beacf42fea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a016c682ceb995c0c2dc1c92410a31b58f04baa9a6bff4580068d3ac8dfa933f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a016c682ceb995c0c2dc1c92410a31b58f04baa9a6bff4580068d3ac8dfa933f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a016c682ceb995c0c2dc1c92410a31b58f04baa9a6bff4580068d3ac8dfa933f"
    sha256 cellar: :any_skip_relocation, ventura:        "89a1d2d02a4e2ead9387eb3184580e40d6d8957dda66da8c19a4f8a964771f30"
    sha256 cellar: :any_skip_relocation, monterey:       "89a1d2d02a4e2ead9387eb3184580e40d6d8957dda66da8c19a4f8a964771f30"
    sha256 cellar: :any_skip_relocation, big_sur:        "89a1d2d02a4e2ead9387eb3184580e40d6d8957dda66da8c19a4f8a964771f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7161f1703f175e6243050e9fb593d391603fb995cc2bc1fb3689e0e7358152e2"
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
