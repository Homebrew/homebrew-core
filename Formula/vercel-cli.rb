require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.12.tgz"
  sha256 "d37a2c0b560f72bc83aaaae15604ff281ed66dae71fe6037c0ceb4192a345e70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d792b31da4c048e79ab43367f24b9453cab1edac76ecbf5ae2a8920984b060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39d792b31da4c048e79ab43367f24b9453cab1edac76ecbf5ae2a8920984b060"
    sha256 cellar: :any_skip_relocation, monterey:       "64d84d9acc8f3586a200aabdc69ebb50120e028338e4eb9eb73a000393053a6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d48f58626efacfb5f0bd4dd48f3f262d684fc99339e31164c4c68cbc8d2f14ab"
    sha256 cellar: :any_skip_relocation, catalina:       "d48f58626efacfb5f0bd4dd48f3f262d684fc99339e31164c4c68cbc8d2f14ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf6f858c7e884ae1cbde2941aa805a3c54a1fd9d503f4304d59a8a65f90b7a3"
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
