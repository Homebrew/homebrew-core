class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.9.0.tgz"
  sha256 "036fad46896482276bb5596ed50d024231ce3bdcd8d4fd3a3b0005db80c29a72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79c4dc9c2f4f276ff6eb0e06c0c98d9c661875b04425a93e9577f0c66149f0ae"
    sha256 cellar: :any,                 arm64_sequoia: "f9c0a85d6b3a67576be4a2ebe6b9bdc9c2570c7b729cd9833f3ec82e45033a90"
    sha256 cellar: :any,                 arm64_sonoma:  "f9c0a85d6b3a67576be4a2ebe6b9bdc9c2570c7b729cd9833f3ec82e45033a90"
    sha256 cellar: :any,                 sonoma:        "ab0310e46d28876618b124a9739a7ea67d0280daed4754fb7f36e74cd6350d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97a224b1251fddef93dd2c85d4797bcabdc55d6cd11d63156a70e509a604bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d031a87461d1c811dc18ba3c3c154832cfe7545669274bcc924f76bbef7a366b"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
