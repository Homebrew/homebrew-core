require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.2.1.tgz"
  sha256 "4e89839946d7fdc4601e135f462f4b4d9fc308d3b2e758e66040d683217069b8"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "efc5b8d087f6ad5ad66271710241bee0ccf1817875553eefcbcf00177d438253" => :big_sur
    sha256 "69a025d44af2e69f182276d619dcc157786220e9eb177a34d46403e1336b92ea" => :arm64_big_sur
    sha256 "de63eefef023d565c9c35e0c780ba2d711c53f12254fd141d8acd12bfd2eaafd" => :catalina
    sha256 "b125e7a8ead0f36a4f43478665de3d214dcbd92905005a5f8e5bc59b5fe50cf8" => :mojave
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
