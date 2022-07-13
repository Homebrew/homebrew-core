require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.1.1.tgz"
  sha256 "51e11d7e85a8c38150844de22bd01064056fb373965086ad3e7b9daa423c620e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "124d3f39bb89721c0dad634db09d73a7d145ca9e59a49f61a8b53c221c89778d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "124d3f39bb89721c0dad634db09d73a7d145ca9e59a49f61a8b53c221c89778d"
    sha256 cellar: :any_skip_relocation, monterey:       "e2a3dd778ac198d704004819db4c0811a6c053868dbc0977e589a65a6c8ca09d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fa9fad687e13b5310a692b8b0be0e2c29fc6f26e9592a456298ae08f1da5ddb"
    sha256 cellar: :any_skip_relocation, catalina:       "1fa9fad687e13b5310a692b8b0be0e2c29fc6f26e9592a456298ae08f1da5ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b179ce31af41ecd6109b2a2c6ae5332a9dd5d472f983df2674d725400e50ba"
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
