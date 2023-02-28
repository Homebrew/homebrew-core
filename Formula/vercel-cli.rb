require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.8.tgz"
  sha256 "f96e13f80bc5d0da1c4c5948911ac2d4b8f93eb2002074216536aef157099833"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e200407fc2cccb50d00b8227c6814b0853c024c18b04ac505efa38c26da063cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb3a9adc03e5ef4a0d0c1e76fec8aa24d9335bce343c44270dc04a4851c62ca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac9a9be5e444536782056d7382e716828556e646ff5997bebf79349440cc2a18"
    sha256 cellar: :any_skip_relocation, ventura:        "946c9d7daa59244df0c8eff716a6e57542cf3959bf0f43d73906d60a649db42f"
    sha256 cellar: :any_skip_relocation, monterey:       "b570fd8bb6e49ff51f4ce9062ae2f87d1716d3458be5d2443cc4e5b9c40def87"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c16076654ba44debec7f89159421bbe44a98afe602f5561b1d99e7ead8290ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "009ed0c62db16973be15657e2111eaed353b421ab58460a55bb76a41e6f6f19c"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
