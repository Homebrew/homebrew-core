class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.4.4.tgz"
  sha256 "59ed5d545cfdedd4438ece361ff050843f144511bf4163b55fab4c21df421069"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8aae2c03cd21d8186a51ae7ef81221e377ea8ce94ac9bb5167912ae0b760d0fb"
    sha256 cellar: :any,                 arm64_sequoia: "f91b41aaacdb82a97ade2f9c07c1225ba2480c4110a4e4e67d4ce6411e4a2460"
    sha256 cellar: :any,                 arm64_sonoma:  "f91b41aaacdb82a97ade2f9c07c1225ba2480c4110a4e4e67d4ce6411e4a2460"
    sha256 cellar: :any,                 sonoma:        "f0f1872457c4b8e3fbedbb41794167646b3bd02066869471bc48b159bd3d275b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b66d264939b2729e7fc0080448b10788ece06d01f3ac63ce1071bc2f78331f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76882f4ca3d684646436bfd825b2f1536a0727b22ad4bc0a480f7d0d0facae41"
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
