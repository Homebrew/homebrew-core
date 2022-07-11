require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.0.1.tgz"
  sha256 "425c7af625a18a59ca2a4b23ca030cf7fc1b0a671b1a529c1b518bb4e4f3f203"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6fd9544e69224d0b109034237e766437932d6ff65c2956bdb722bdf8f367f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c6fd9544e69224d0b109034237e766437932d6ff65c2956bdb722bdf8f367f2"
    sha256 cellar: :any_skip_relocation, monterey:       "7bba251dd3142ad73d03bf1964fb16daf134415fd15c50b7843ffc991b1379a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ce4627274e468d0e66349d39b48c09b339f590bdf78b949f5939bfb7258f900"
    sha256 cellar: :any_skip_relocation, catalina:       "6ce4627274e468d0e66349d39b48c09b339f590bdf78b949f5939bfb7258f900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ef4a0b6c67f797ab4ee3924d6b70eff65e8a330759384c86017bbc2ca24be62"
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
