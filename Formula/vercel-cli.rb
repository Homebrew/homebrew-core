require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-23.0.0.tgz"
  sha256 "69ca0631ca88bc2913c6600efc133b6dab52b16856722174b4dac107d3bab1be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d550730cb1b732935361c1ec71c71ea173050b76e235bb8de3aace22263a54cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e82b36f6269fc7c8f98d682acf791127e391c6ff528d9b1769a9bbaaaf7f07f"
    sha256 cellar: :any_skip_relocation, catalina:      "4e82b36f6269fc7c8f98d682acf791127e391c6ff528d9b1769a9bbaaaf7f07f"
    sha256 cellar: :any_skip_relocation, mojave:        "4e82b36f6269fc7c8f98d682acf791127e391c6ff528d9b1769a9bbaaaf7f07f"
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
