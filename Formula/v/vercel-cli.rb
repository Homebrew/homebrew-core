class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.0.0.tgz"
  sha256 "5b4c9dde44a8bda4187202d514eaf6bb27a716d734de19aaf015c6d583f3b7be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76e6ffcc755f6dd74bb33ba9889b45fc26754ff9a6f1920798517ccbc4b96ae2"
    sha256 cellar: :any,                 arm64_sequoia: "9fa2e59110fcdfb1e161e6380eea4b9e26bf8b5b5a5abeb3f060223dd1ff1ef0"
    sha256 cellar: :any,                 arm64_sonoma:  "9fa2e59110fcdfb1e161e6380eea4b9e26bf8b5b5a5abeb3f060223dd1ff1ef0"
    sha256 cellar: :any,                 sonoma:        "ac9cef1dfb47ddb26b2156341a1182de9c77292b767db3c1a0ec5706f6759204"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79b30e4cc85470fcaa25e03213420e22fa65f2023da2600f1cb2ea1681de434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b522cd45ebe4549e2bbb50b481a24cf133255024ad8f5f47dafc24727dcdbd"
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
