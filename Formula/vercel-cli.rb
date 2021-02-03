require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.2.2.tgz"
  sha256 "6b51ebd87b6f8da801a19620e058a303b7a9078d868f7b87e6067d14f111aba3"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "14898515b34eef752230b77a29474d843a8d446ff05570dedaea495a6c4db773"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b1625cbeb9e146fa3dce6b7a8a9d77860ddb92314169056985ea1cb84cc0d97"
    sha256 cellar: :any_skip_relocation, catalina:      "5f1ff0f828e5cf8ffbf4a4f00dee0096d46975986aeccea9f56c178c7fba13ee"
    sha256 cellar: :any_skip_relocation, mojave:        "df1de79b6830d01ae33454ef939aad4aead5437a808a8fa27d6f123690403da2"
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
