require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.11.0.tgz"
  sha256 "7b30ef640270e7e613aa781d695fe15a61045bc5b597421523efb6614d446692"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abe80003c3388e023989df91c28c7bb1b82b0e937a7cb58f6b67ccb705128612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abe80003c3388e023989df91c28c7bb1b82b0e937a7cb58f6b67ccb705128612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abe80003c3388e023989df91c28c7bb1b82b0e937a7cb58f6b67ccb705128612"
    sha256 cellar: :any_skip_relocation, ventura:        "bf5525f171138f764b01338592726068c20f37ea0148592f31de42259ac51175"
    sha256 cellar: :any_skip_relocation, monterey:       "bf5525f171138f764b01338592726068c20f37ea0148592f31de42259ac51175"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf5525f171138f764b01338592726068c20f37ea0148592f31de42259ac51175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd60699b032c5f898aaef6d503de9e47f9d74d9683de9ce2dc7d9d163b956c92"
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
