class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.10.5.tgz"
  sha256 "0bc0053e5dd8ab5b844e09015a36c5c8ce292d091b9738a3059fb5e9335d7ec8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9373af26df615973b3307718cc0f3639248176e847a2c91ac71b95a6e306f822"
    sha256 cellar: :any,                 arm64_sequoia: "82a9ddeb6fec7ba1f68ab47ce2b5e2ed45aa600a3da1b35a505eaf80770d7132"
    sha256 cellar: :any,                 arm64_sonoma:  "82a9ddeb6fec7ba1f68ab47ce2b5e2ed45aa600a3da1b35a505eaf80770d7132"
    sha256 cellar: :any,                 sonoma:        "7495e66be785073fc5e03909f05bb208bc051918cdd49521953d233233f57891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe3e926f6ad1fe760aa50993911ab2a69f1a2da715ce5f669d90a7270d401df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe55767e77b33d752790416a7e5f494f94ffcb9346bb78a5caee1d36d7f4d08"
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
