require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-25.2.1.tgz"
  sha256 "020a90d68a769334aa418fd0d78274d1082e993d4603a12095fe1aa00c77bbef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d22124011921875210a3d9fe505c4b8dd89a6b925aa0a9fedc413e9f28abf39c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d22124011921875210a3d9fe505c4b8dd89a6b925aa0a9fedc413e9f28abf39c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4ecc518bb84586fc3db821b3da9640fb2f2335372355ef284e431d91848c874"
    sha256 cellar: :any_skip_relocation, big_sur:        "cee62aacfb7c7bc7035281cc7d4c8edea3575da48e068ef7f5e39fd160205f96"
    sha256 cellar: :any_skip_relocation, catalina:       "cee62aacfb7c7bc7035281cc7d4c8edea3575da48e068ef7f5e39fd160205f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc64bdbea0b9f91034a34d853d44a8a1f1208ec80d4952cb720a8c7dd1d1c7d"
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
