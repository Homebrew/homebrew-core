require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.0.0.tgz"
  sha256 "2c898f2f941943dfa38c86c5ee4d6b36e856c2be9bd6777fef60608197591529"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ddbbf53a436405a062c8275d0b57290fc83480381c3d036070ed839f821de57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ddbbf53a436405a062c8275d0b57290fc83480381c3d036070ed839f821de57"
    sha256 cellar: :any_skip_relocation, monterey:       "16ce8070c831dc68e341b8922fd4c909281ef030f61ff0ffd5b89e3a6ac6c714"
    sha256 cellar: :any_skip_relocation, big_sur:        "254da43700198b345dedd20716a0175f93dbe7525b7c704cbfb953a50d668230"
    sha256 cellar: :any_skip_relocation, catalina:       "254da43700198b345dedd20716a0175f93dbe7525b7c704cbfb953a50d668230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e1bb17c3bbca39e898b9997084a905baff9993d3bb43b85da2d9c23a51da12"
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
