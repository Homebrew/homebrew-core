require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.15.6.tgz"
  sha256 "8738c0b59262f042a7908617f9030a4f89de44afffd5e0d20cb38f6a381d654c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c11efa11b711ea628ce310168e41539af266573de0e1ea8d43c2ec23077df4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c11efa11b711ea628ce310168e41539af266573de0e1ea8d43c2ec23077df4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c11efa11b711ea628ce310168e41539af266573de0e1ea8d43c2ec23077df4b"
    sha256 cellar: :any_skip_relocation, ventura:        "6127f6d93eec73d5e8f27f065de54031b05a91068c7510232b3a6bdb13f72b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "6127f6d93eec73d5e8f27f065de54031b05a91068c7510232b3a6bdb13f72b6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6127f6d93eec73d5e8f27f065de54031b05a91068c7510232b3a6bdb13f72b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d1e721e3871c8b836404d461d5530dbe8b8e5c9d5df9e4c164063cf9936a81"
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
