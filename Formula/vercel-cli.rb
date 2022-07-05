require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-26.0.0.tgz"
  sha256 "4ba24e0f5844e8ac713bb5fe06de85623ea7943542569c19553839f563e20eb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f8caf13d8f825bffbbd91e4cce7d9c2f81468fa6eb20b270bdb79bebab59b51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f8caf13d8f825bffbbd91e4cce7d9c2f81468fa6eb20b270bdb79bebab59b51"
    sha256 cellar: :any_skip_relocation, monterey:       "be272399a27f38565296537e3222108507e1d2c2145dbfdefc4347afa52298a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2802fca54d3c0c70fe73924e15b42456ebbaf0482933a42644d56c968cbe24a"
    sha256 cellar: :any_skip_relocation, catalina:       "d2802fca54d3c0c70fe73924e15b42456ebbaf0482933a42644d56c968cbe24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f47ecbe7292791c728d57c0e72f85b285d9bf39cb954382d1b7635ee974613"
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
