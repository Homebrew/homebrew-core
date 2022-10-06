require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.6.tgz"
  sha256 "dd4be3a093ec4e70afab5509792e2337fbe76031f16ade633e50bf32a5ad2d4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a131f18fc45c007ad7fe46d577bf450df6f3d03c90e2ea007525c183e475f8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a131f18fc45c007ad7fe46d577bf450df6f3d03c90e2ea007525c183e475f8c"
    sha256 cellar: :any_skip_relocation, monterey:       "7f3664986451e18281fdb40c7ae97b8c28df0cf67a95a8c74371afc295634e8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "52e11f4aeb4d1e8d82e7488496759070453c01e63ca7e54d31664d67404fdb8b"
    sha256 cellar: :any_skip_relocation, catalina:       "52e11f4aeb4d1e8d82e7488496759070453c01e63ca7e54d31664d67404fdb8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8031ccd40aaf69e8bc7745ce44d2126f97298fceefe53c822ecfade2fba01f98"
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
