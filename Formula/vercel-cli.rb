require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.15.3.tgz"
  sha256 "bb9913f8b5e73b72e02e9a90754628952788b528b6a725a9695d073ff794f134"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c30b8aad2b432769e10c4c621770163a7f53621c2f5797b20194606d92a67132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aa7b4dff8fb335829664b90e73dc9c58ec61b41c3e06d7707bf1d653cacc95f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b6539046d436b753d78b49aa7c2912d9433e2b77777da4d16cdde1972a09317"
    sha256 cellar: :any_skip_relocation, ventura:        "1f5555324794a823dfbcd4c2206dc6de9c281c962118d2952b3ea35c9969b134"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c71cae4d3b71b18c683d125c2d4b4ed7b478e8d0cdc7801b4c79efce99affc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b2a3be52107691758cec36a3388cb9955b5a6983e06a141de5173b8c9f5af9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303e68410e792c8991af82deaa1019452880ac65b77107ddbb2b2522e42cfd5a"
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
