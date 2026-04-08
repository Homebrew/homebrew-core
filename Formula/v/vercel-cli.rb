class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.42.0.tgz"
  sha256 "069e28dc117a3541cb0b77f1110e557865d6c05618ce711a5c5e82baeb6d18b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f839d1b3b40137b2040aaa9d22f25e150d3861c33d6f01bf48af6908a593066"
    sha256 cellar: :any,                 arm64_sequoia: "9f3be21667d89627cb79a102c4baed44166557ae93f5a1cf6bfc6631931aaac0"
    sha256 cellar: :any,                 arm64_sonoma:  "9f3be21667d89627cb79a102c4baed44166557ae93f5a1cf6bfc6631931aaac0"
    sha256 cellar: :any,                 sonoma:        "0681db0144512d120fd088ba8394e9a002397a7bc7721e1c23dc8d1a46523680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bda44071f29c7f00c7955b39d7e9307c24b8aac264e22295e5c58fad273a553a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef2f8175ceab17dcfb3d1afc00b57f4f8e96bdf1800c2ee8444aaf59226718f8"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
