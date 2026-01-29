class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.9.1.tgz"
  sha256 "3c88888e29d67fefef137cea25220030fb2d344ba6830ffe331e9e399aa3ae2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96518bcfb2f30c9ec3cd42ed2674f47bdecf91186cfad6778ec80a575cd3b21e"
    sha256 cellar: :any,                 arm64_sequoia: "864646c1256dc2e676c66d009f585ba3340df1a30ac3bbdda81dea2f67d247ec"
    sha256 cellar: :any,                 arm64_sonoma:  "864646c1256dc2e676c66d009f585ba3340df1a30ac3bbdda81dea2f67d247ec"
    sha256 cellar: :any,                 sonoma:        "54800a5e87d92bb15e27b952609fccd9d29607c94f5bd0cc7a49a501940a6553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75be8915d83eb7834d17f0fb5cfe814d283b31196061ed833571493ab86a5e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6914641eaaf7319360654de573f54ea12529ce42847bb1bed3bad2eb990e0f62"
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
