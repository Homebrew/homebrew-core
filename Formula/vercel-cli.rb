require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.11.tgz"
  sha256 "704aabf5f4c93385faa48781a7f6c0dbbddeb5cb0e48325ab99939b117fd5f0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc9f0fca41fe76aa6a55638cbdf7a53292075dfc2d07cb1f96d4bc2c1dd1e022"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9f0fca41fe76aa6a55638cbdf7a53292075dfc2d07cb1f96d4bc2c1dd1e022"
    sha256 cellar: :any_skip_relocation, monterey:       "7506e57120c38af899bad47765d995d4502e0cab4eda21895f64dc1245aff513"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ba322180b8c3d1cab59c931277c2074dda2026f6ff6bf6dc9c365bde64e5c42"
    sha256 cellar: :any_skip_relocation, catalina:       "9ba322180b8c3d1cab59c931277c2074dda2026f6ff6bf6dc9c365bde64e5c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5170742b822ba5e6a963c60eb90acfd6830d8f1799f0fbaf00e2212fa51e99e"
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
