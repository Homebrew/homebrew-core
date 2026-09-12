class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.3.2.tgz"
  sha256 "d25fc8c4f2f2a41b05221f3a0b45f6409d5f2b3b62837dd320d4d522296b070c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "359e12f3f85307ce53738e826e9eee89ee53db572a0c6799755d4c24b30d2b0e"
    sha256 cellar: :any,                 arm64_sequoia: "359e12f3f85307ce53738e826e9eee89ee53db572a0c6799755d4c24b30d2b0e"
    sha256 cellar: :any,                 arm64_sonoma:  "359e12f3f85307ce53738e826e9eee89ee53db572a0c6799755d4c24b30d2b0e"
    sha256 cellar: :any,                 sonoma:        "8b162c9f3fc5f13c7cf5fbd237f1ce00540304545b67199ae7d698d2b1e0515c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e774db0e052ec8fb1ff1eb150141e3a49be2d16776e49c026c7a4f2d53c579c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "360bc56b7bc4df22ea9c0158253a9dddcdd989e521bc26164aa3f7d0913651c5"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

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
