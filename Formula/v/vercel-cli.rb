class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-51.8.0.tgz"
  sha256 "ba2c447a08117489da60a9f3d8a0bd50aa3a4eaf1c9d5dd9c0cc789342813be8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b187d18ffc87faa8b1a570c9dac8b970e8b261359e347ff6bbeb2ef9c9abd69"
    sha256 cellar: :any,                 arm64_sequoia: "bac97bd6b5712e8669ba06694e918e03a56c9346e435c7630fc2d8e8dd9469fa"
    sha256 cellar: :any,                 arm64_sonoma:  "bac97bd6b5712e8669ba06694e918e03a56c9346e435c7630fc2d8e8dd9469fa"
    sha256 cellar: :any,                 sonoma:        "97ff093f68e1445c1a2771c58bf745e93bab6f2570c2f94f05a0d35d98231ce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "700ff46f173a798579d2bb22102bb2b320e66d837ef754ed4dd539bd22d4b7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac7c2f1105e46be869c5adf5f6fa977db1ba3e689aa65d888f73879e941bdf2b"
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
