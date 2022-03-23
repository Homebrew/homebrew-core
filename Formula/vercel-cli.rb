require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-24.0.1.tgz"
  sha256 "956ce191cfaa4b7fe5a62d1e0f8d9900fb4a7d88ff5fab9c9a46f7acefe24b62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "050a75a537399108a75684f79e9febef8d490c4b70fdf2586356e1d29b22e984"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "050a75a537399108a75684f79e9febef8d490c4b70fdf2586356e1d29b22e984"
    sha256 cellar: :any_skip_relocation, monterey:       "8dbe60cd6b7e8cd40200bb87b246909e7d850dfb0067ea99f386ee8adbbf9f52"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dbe60cd6b7e8cd40200bb87b246909e7d850dfb0067ea99f386ee8adbbf9f52"
    sha256 cellar: :any_skip_relocation, catalina:       "8dbe60cd6b7e8cd40200bb87b246909e7d850dfb0067ea99f386ee8adbbf9f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ea919452075c2b6b5282ba7858edb7a86a4e2a9de31f1eda62af1a70d7f768"
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

    term_size_vendor_dir = libexec/"lib/node_modules/vercel/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    dist_dir = libexec/"lib/node_modules/vercel/dist"
    rm_rf dist_dir/"term-size"

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(dist_dir), dist_dir
    end
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
