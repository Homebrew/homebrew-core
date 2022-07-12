require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.1.0.tgz"
  sha256 "b71a350004cb0df9c4343f61c7006edd5531da2c81724aa21f08aeef2e1d599c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72107f6c7e6c590531a7b76caf38aeda498670dd2fdbf2bfa4acf359cfc4ce12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72107f6c7e6c590531a7b76caf38aeda498670dd2fdbf2bfa4acf359cfc4ce12"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2ed8d7407fee5c6f24012391a35710fc5c07e01e49ed1959113d55dfd830f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "42fce72c4ed9caa9364e3b0054950a6f194ab9e7fa1fb0ae8f4377977376775c"
    sha256 cellar: :any_skip_relocation, catalina:       "42fce72c4ed9caa9364e3b0054950a6f194ab9e7fa1fb0ae8f4377977376775c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8822cd3c487472787217431d3a652caf09878bbae9a9a77a2b74282f02e3cdac"
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
