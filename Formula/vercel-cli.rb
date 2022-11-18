require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.5.5.tgz"
  sha256 "52a13693cc8c4fc7eceeac7b1177063752e77dc68e3ff725c6fe85a103412244"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eee21c10d419dc08cbfec940ec8b835914b715dfa38a3a0d50f603739fccf99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eee21c10d419dc08cbfec940ec8b835914b715dfa38a3a0d50f603739fccf99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0eee21c10d419dc08cbfec940ec8b835914b715dfa38a3a0d50f603739fccf99"
    sha256 cellar: :any_skip_relocation, monterey:       "3463838b4639664a6b5d4986de7cbaba281a8544662f214da8534585940f803b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3463838b4639664a6b5d4986de7cbaba281a8544662f214da8534585940f803b"
    sha256 cellar: :any_skip_relocation, catalina:       "3463838b4639664a6b5d4986de7cbaba281a8544662f214da8534585940f803b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5057b4ece8ff99da3dc3026b726131b14d6e4a541f527d1fe927513716898dc4"
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
