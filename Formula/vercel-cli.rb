require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.4.0.tgz"
  sha256 "9b59a83a5b47c285d0baab4e076f60104debc4a5e9ce328379a13a0a374ce5ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0704c5dfe2c844c14493f6fadd38e016ad3bb3fa79d6bccf640a3c3c61950407"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0704c5dfe2c844c14493f6fadd38e016ad3bb3fa79d6bccf640a3c3c61950407"
    sha256 cellar: :any_skip_relocation, monterey:       "14b339bfc184d97865eb512639e5873a58e95670692cd0e4f8dcf50659c76465"
    sha256 cellar: :any_skip_relocation, big_sur:        "380b2c7fb5f8a9261352f3a8c0972e3494fa45f503fe5a46b5d2c9ed8add05ca"
    sha256 cellar: :any_skip_relocation, catalina:       "380b2c7fb5f8a9261352f3a8c0972e3494fa45f503fe5a46b5d2c9ed8add05ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "517254c72e2169a8d037e31969dcb168bd4e9fc1914cb3a8f3351053d28b6771"
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
