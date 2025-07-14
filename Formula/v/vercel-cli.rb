class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.4.1.tgz"
  sha256 "59a963b1ef0c9f68f5b48080a80fad6f1182eb0db65ed54aa0bf5c91501b2e58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38bdbc9b2c8761e4fd004a1f8e5f2cff7c47fa99d643caadb036d66de47749dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38bdbc9b2c8761e4fd004a1f8e5f2cff7c47fa99d643caadb036d66de47749dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38bdbc9b2c8761e4fd004a1f8e5f2cff7c47fa99d643caadb036d66de47749dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9eac02e6652dc94f726a6a8c715438056296ae4643ec223469877f34bdefde8"
    sha256 cellar: :any_skip_relocation, ventura:       "a9eac02e6652dc94f726a6a8c715438056296ae4643ec223469877f34bdefde8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7530c99f1d489057d355112beb12b19554fc21d19954bf9d1d7c418b2e78e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bf3773ddc11c6e35ae003d7d71537dacfeb53c9de7178428fbb6a0736353d0a"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
