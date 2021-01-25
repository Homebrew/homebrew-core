require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.2.0.tgz"
  sha256 "9d4ecc02aeae05c7825711d7873d0c769e123d7ce177c3f4c34a95f2ecc7c44c"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a843f9b77b54a36965efaecb319513000afc9cf2e2cd20af484b13e3075cd9ea" => :big_sur
    sha256 "e34d6fc77c0f48e4e32ecdb0ce976addc3a0b7e765323d0406036ab7334708fd" => :arm64_big_sur
    sha256 "3b2522d085f1f7900062c43c274e910001cffc538f8bd7e06002edb2c5af57f4" => :catalina
    sha256 "e2dd181480ab734e9addae4cc12ca2dd63d75730546ea9652026223e0fc5e984" => :mojave
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
