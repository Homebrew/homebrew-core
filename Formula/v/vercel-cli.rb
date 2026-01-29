class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.9.1.tgz"
  sha256 "3c88888e29d67fefef137cea25220030fb2d344ba6830ffe331e9e399aa3ae2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1b5c1b79a9e801d5cb1bce590699715424c561a91b7f492a647deb72de5b0f3"
    sha256 cellar: :any,                 arm64_sequoia: "5271f15f7dfd566acfebc39d92e6e4fb5a2a6d7272389dfe5327d6f528467883"
    sha256 cellar: :any,                 arm64_sonoma:  "5271f15f7dfd566acfebc39d92e6e4fb5a2a6d7272389dfe5327d6f528467883"
    sha256 cellar: :any,                 sonoma:        "1cf61363aff95a52c782238aa99d20f9769588cd4e8eaa985396f8aaf57cc584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca20479862aacc0ee4bdad9b5cd9388cab04eb85e8f11df711f2e168d39d27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68d91c6f7b26a2c7e73fd0c9281ff68ec3d3a530a7c90d8ff580c46c0fd766f"
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
