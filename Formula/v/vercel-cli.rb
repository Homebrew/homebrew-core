class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-53.2.0.tgz"
  sha256 "3bef55043c7d5ace96ff8b5ad20b1237c5b4e9e6698ce7ef914d4c44d0685ecd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "028ea1cf65b80d6cf61382b4287bf6b97b698fbedcf65966c641a0e1f9a8d9c9"
    sha256 cellar: :any,                 arm64_sequoia: "15d2e2c0555593f6e6be1702a757cc52ec8fd3388fac2af92e651d4d7a603513"
    sha256 cellar: :any,                 arm64_sonoma:  "15d2e2c0555593f6e6be1702a757cc52ec8fd3388fac2af92e651d4d7a603513"
    sha256 cellar: :any,                 sonoma:        "05d51ca9acbaba7c0b2ae00d9466ce3555184e4714fb3878d3770c0394ae3f4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79d98871a64cc1fe2254140d0839192151a44f559fc5e7fedf47672e93875003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c087a99c8fb91bf3c30f6ec14718a448fe01aae8937f2508ccd303822d19e7a"
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
