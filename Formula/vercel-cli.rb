require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.12.5.tgz"
  sha256 "16e226cd1961635fdab5aacf7d5905da3d4b62545e88974dd7220e617be9075e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8ae9f4c55c2dfcb469848e6eff548ad11b3d046ff0ae6fb2aa7afb53d4e93c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8ae9f4c55c2dfcb469848e6eff548ad11b3d046ff0ae6fb2aa7afb53d4e93c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8ae9f4c55c2dfcb469848e6eff548ad11b3d046ff0ae6fb2aa7afb53d4e93c1"
    sha256 cellar: :any_skip_relocation, ventura:        "94bea5e98e9f7433e5d6827eb2c49b69b66eef9b12ed05e2176f3a5ce412ddd0"
    sha256 cellar: :any_skip_relocation, monterey:       "94bea5e98e9f7433e5d6827eb2c49b69b66eef9b12ed05e2176f3a5ce412ddd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "94bea5e98e9f7433e5d6827eb2c49b69b66eef9b12ed05e2176f3a5ce412ddd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa0f491cbcd11bf99fd27d2e52ff19e141e70c2612917776b499c517dda2712a"
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
