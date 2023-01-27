require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.14.0.tgz"
  sha256 "1b2a0b8e12b5221634cc0bb2859116ee70f0769ec5d60d139a05cb55c57ff350"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29c265229e76ac83b3eea37ab2ae49d1844c16ca215ace67707369d81037f862"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29c265229e76ac83b3eea37ab2ae49d1844c16ca215ace67707369d81037f862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29c265229e76ac83b3eea37ab2ae49d1844c16ca215ace67707369d81037f862"
    sha256 cellar: :any_skip_relocation, ventura:        "3af5137819c72420c4cd4cf10d95d1207edb30814e4858ed66708f5f4e34f525"
    sha256 cellar: :any_skip_relocation, monterey:       "3af5137819c72420c4cd4cf10d95d1207edb30814e4858ed66708f5f4e34f525"
    sha256 cellar: :any_skip_relocation, big_sur:        "3af5137819c72420c4cd4cf10d95d1207edb30814e4858ed66708f5f4e34f525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "124616b24c42187eb9f3283f2463a0645335bc80818b829dc91566148891403e"
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
