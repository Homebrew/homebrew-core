require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.1.0.tgz"
  sha256 "7cf5e8965e007699b3e688949ed6345280d592d81e558ee44214118d0dde91f7"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8ac52deefe82f33c081ce0d58db7913f499ef2b524a236dfc8f873f13a9233b0" => :big_sur
    sha256 "3c103c1cfbc27e1cca185f4ab4c02bd562698e6d691d143dcabd053cc88e7df0" => :arm64_big_sur
    sha256 "566e84e83bfa4893fe4f7e14deda0d80a9c72880d50cefcc880377663b75f1e5" => :catalina
    sha256 "00e29669fdc92df884451bc3c1174b7899ddcfd2b9fb78a6b4457ec924e57d52" => :mojave
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
