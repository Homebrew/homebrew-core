require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.13.0.tgz"
  sha256 "f6e865146433f8e4eff6696281c5a902d7011ff0c05753d470173ee0179f84a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9fe8296a1c2f2cf4705e9e19295cea78cca491d6c0f33b840018a1b5522ff62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9fe8296a1c2f2cf4705e9e19295cea78cca491d6c0f33b840018a1b5522ff62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9fe8296a1c2f2cf4705e9e19295cea78cca491d6c0f33b840018a1b5522ff62"
    sha256 cellar: :any_skip_relocation, ventura:        "636da42071715c38239981349c30374f8f52df763d8e9b8788fb7a531072919d"
    sha256 cellar: :any_skip_relocation, monterey:       "636da42071715c38239981349c30374f8f52df763d8e9b8788fb7a531072919d"
    sha256 cellar: :any_skip_relocation, big_sur:        "636da42071715c38239981349c30374f8f52df763d8e9b8788fb7a531072919d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a788e20e79f0091de93fd7e74c6242b483ca9309f72f3e810c36e6193178939d"
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
