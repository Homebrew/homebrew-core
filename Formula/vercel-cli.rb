require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.5.1.tgz"
  sha256 "bb94247e8ad64b02d1627ccacbc69a6d2eb763050c5c3df02b2f84e2c217fdab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f1dd161287e5576ddc32cefaae34ac91b6c5bb05f52bdb500656d91bcb80c65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f1dd161287e5576ddc32cefaae34ac91b6c5bb05f52bdb500656d91bcb80c65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f1dd161287e5576ddc32cefaae34ac91b6c5bb05f52bdb500656d91bcb80c65"
    sha256 cellar: :any_skip_relocation, monterey:       "ccaf4c0ae376ffbdd0c076685e4f02060411108298759b4a2d5c46ab8c48793e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccaf4c0ae376ffbdd0c076685e4f02060411108298759b4a2d5c46ab8c48793e"
    sha256 cellar: :any_skip_relocation, catalina:       "ccaf4c0ae376ffbdd0c076685e4f02060411108298759b4a2d5c46ab8c48793e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9348e1a8d767a719b1f95143e1dd9ef1fffcd9ffd8b1bbbbf43619f02c7cddb"
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
