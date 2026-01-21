class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.8.tgz"
  sha256 "016cea4a206bca4cb90d2c5624ff8c615852ba90eb6fc081148925042bb77046"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97864d4e19b950bc8ca289de43c18a4bc21448e17cd49f4b6d0b991d58edf1bd"
    sha256 cellar: :any,                 arm64_sequoia: "b2af956d2501d4b232a5c9ab6ff22b39f4d4092a1db72c723426d328018cf4a9"
    sha256 cellar: :any,                 arm64_sonoma:  "b2af956d2501d4b232a5c9ab6ff22b39f4d4092a1db72c723426d328018cf4a9"
    sha256 cellar: :any,                 sonoma:        "8ef36e5e5e8d6aa80bd6f9fd1285fdb1412eb35493bfddb7353fd5d2d24b3866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2d39067206e30ada36d9ef3e570d6754c35acb1c299de0338c46e37ba0df4a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db231c0d3efdb4f23a337be1f776f81f3ac101374914a5394cb769404a5e129"
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
