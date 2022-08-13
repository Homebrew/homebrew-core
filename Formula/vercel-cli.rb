require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.4.0.tgz"
  sha256 "9b59a83a5b47c285d0baab4e076f60104debc4a5e9ce328379a13a0a374ce5ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5475f81b62ad48cfee8eabc522a9ccf20ef52cfceb8d97d7fbf38fa907477649"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5475f81b62ad48cfee8eabc522a9ccf20ef52cfceb8d97d7fbf38fa907477649"
    sha256 cellar: :any_skip_relocation, monterey:       "8e9b4c68a600647c1c322ce2e3ccf2d4b916af4bda580a986c12dfe2486f84b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "70a54fa44bd59c6cb74a5546a5324e6dd772fc5341b702c4d5ac2ef16b14b119"
    sha256 cellar: :any_skip_relocation, catalina:       "70a54fa44bd59c6cb74a5546a5324e6dd772fc5341b702c4d5ac2ef16b14b119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "317c3a6035655c4b244a002ce13136fdf3541a88b79c9b1aab9c2b5023328b49"
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
