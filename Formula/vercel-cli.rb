require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.9.0.tgz"
  sha256 "94d53069846bb3e1dffc4ed4fd548d957689249c6e6c84b0366f7958ca9ea588"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bff96a45f4dccfee3e4d2356b5e51288911972567231a834268aa28f9e3ec40b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bff96a45f4dccfee3e4d2356b5e51288911972567231a834268aa28f9e3ec40b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bff96a45f4dccfee3e4d2356b5e51288911972567231a834268aa28f9e3ec40b"
    sha256 cellar: :any_skip_relocation, ventura:        "3bc3c1e636e4e45f39812636b96dc47e5a123a11a0ff0b8987c3e9512958f2d8"
    sha256 cellar: :any_skip_relocation, monterey:       "3bc3c1e636e4e45f39812636b96dc47e5a123a11a0ff0b8987c3e9512958f2d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bc3c1e636e4e45f39812636b96dc47e5a123a11a0ff0b8987c3e9512958f2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d03a441e1177bab59763c5e055042057bc9a9a1bffa7529d036c268058601a"
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
