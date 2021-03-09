require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.3.3.tgz"
  sha256 "e2b0d36af7ca06839075a2a8eda6b15087ae9fa9a76c073bfeaeebe4e1e0c71f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8f3c8ef6c2a2ef12137cdcea5cb732628c9c920a8950f9508a4070e39cdd32c"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d3370861bfb990c207e8cc340e9143822366ca0ff72bdafa5d58fc37969ca41"
    sha256 cellar: :any_skip_relocation, catalina:      "4f40cc1263dd6d90dc5b78e3bcb27f33592898034fba02eac99583ee893e9c0b"
    sha256 cellar: :any_skip_relocation, mojave:        "51e052f8d722003f300276ca3bf9f966b116e398a76fbc599fa1cf62df58183a"
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
