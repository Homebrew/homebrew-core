require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.2.3.tgz"
  sha256 "0628b029719b8fcc0ee4812c0ad5379226b65e858bad013dc9aaf2c9fcb03895"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d873f60196eb679baf4f95ca1d6b98892f4c2918c845e93a66a64db321a626d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9abc682c893410a630752b8d07e214d72b4c4d61afaa2fd42dbc716e8279373b"
    sha256 cellar: :any_skip_relocation, catalina:      "cb7e141d7faf06576144eafbdd801c6d6303b49b96517e7792c00a0006957982"
    sha256 cellar: :any_skip_relocation, mojave:        "ea477fdf61b98c95c7de300cab1906f9ce58d267dda592d5d36807fe66739a47"
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
