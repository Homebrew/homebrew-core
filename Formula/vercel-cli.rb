require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.10.1.tgz"
  sha256 "7cb66bd4a971e8d3108d7e73cc9e7d8a4c7734dae867aa079b8165ebfa03ed70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8cb4637db72cbb27e138d95957ff2f4d68ea9c93575c7d31b497d167072d2a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8cb4637db72cbb27e138d95957ff2f4d68ea9c93575c7d31b497d167072d2a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8cb4637db72cbb27e138d95957ff2f4d68ea9c93575c7d31b497d167072d2a4"
    sha256 cellar: :any_skip_relocation, ventura:        "ceb523051d9d54b4ebdbf9f3561627ac3480b2fa94e6a2ebcd71e80413efacb3"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb523051d9d54b4ebdbf9f3561627ac3480b2fa94e6a2ebcd71e80413efacb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb523051d9d54b4ebdbf9f3561627ac3480b2fa94e6a2ebcd71e80413efacb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e5c9ee1fa8ce08e46048b64a491436194102af523ef018bb4c635b4e933a36"
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
