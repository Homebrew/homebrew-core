class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.12.0.tgz"
  sha256 "06895d97c981b9a16e892d40fc524788811d4d8714c6b37f383c2c6b6097671b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a04ec07783c483f3af69107cdb500c8d1f9f62093144f842da38c52d435a4868"
    sha256 cellar: :any,                 arm64_sequoia: "dd6cd754265da1ec17f50d92a5e2d835e3f624ed786a98726cd85a8fe53c24da"
    sha256 cellar: :any,                 arm64_sonoma:  "dd6cd754265da1ec17f50d92a5e2d835e3f624ed786a98726cd85a8fe53c24da"
    sha256 cellar: :any,                 sonoma:        "0228404045ceddcb8366c25a40a55f6b3797987183a9657a27246a2b707ae25d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39c40d144b6c28c30b0344279ad691a1ee39651aa5e9f6bdfe88caf588123f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "347a73f451d6daebfd6e1f928d7d607a212b516386e64e5c90362e41b45db014"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
