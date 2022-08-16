require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.0.1.tgz"
  sha256 "b8b3b1049ca1672e070de9645b273cc39eee31955b2c4754e955e6f5f991a2e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e69f26fd9d914dbcaa7046856861897eb4e2d6d9649166bfc88c289cf4901c90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e69f26fd9d914dbcaa7046856861897eb4e2d6d9649166bfc88c289cf4901c90"
    sha256 cellar: :any_skip_relocation, monterey:       "d402b157814f293be6018c08dd0a15f529e4b96a22f67f0dbc1cb12b01d30cc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "78202607b77b0643c76fc50bf4ab173f75f7533fa11f5194e3ee39ecb47716bc"
    sha256 cellar: :any_skip_relocation, catalina:       "78202607b77b0643c76fc50bf4ab173f75f7533fa11f5194e3ee39ecb47716bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c046adb848479214b15f2e6b3b580ee08260ed0e16160383dc38878bbfd09636"
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
