class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.9.1.tgz"
  sha256 "507ded0d5faf29cf78f7ec583ff303f10423369683b9739fcb636594a1d1c43e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b354f071325d210ff5637172061596a2e0d8adfe013780e0619fd40f1556773"
    sha256 cellar: :any,                 arm64_sequoia: "93f9e3b2c3b2a14e363b7cd94118606d0058a5719b9a1a6fc7acc8ef3cbbd55e"
    sha256 cellar: :any,                 arm64_sonoma:  "93f9e3b2c3b2a14e363b7cd94118606d0058a5719b9a1a6fc7acc8ef3cbbd55e"
    sha256 cellar: :any,                 sonoma:        "88013ec4aac7ce66a5a81adb84816d9fe15f46dc6e2f9267aff8e63a3b002c76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ebd981c5d64d64b314c6c8233bdb1e109eb6b2e4291bb7655bbe9c819259f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb500c0ed6edf5963c4ac906eb61e9c93e227046a70c7272511143440feff4fb"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
