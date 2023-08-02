require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.2.2.tgz"
  sha256 "342809344a704e98d12eeaba94e9e64631b83963abb0825c07dcfe4b9a791944"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12b3789a25d6f3e2615d3ce1777e80b1ec56d7ce52a4fbf35d615e0cd5a32aea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12b3789a25d6f3e2615d3ce1777e80b1ec56d7ce52a4fbf35d615e0cd5a32aea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12b3789a25d6f3e2615d3ce1777e80b1ec56d7ce52a4fbf35d615e0cd5a32aea"
    sha256 cellar: :any_skip_relocation, ventura:        "53ad919e8f862d8e7e7941bc99f3e4582698d4b97c2f557c2869a10b11ab5706"
    sha256 cellar: :any_skip_relocation, monterey:       "53ad919e8f862d8e7e7941bc99f3e4582698d4b97c2f557c2869a10b11ab5706"
    sha256 cellar: :any_skip_relocation, big_sur:        "53ad919e8f862d8e7e7941bc99f3e4582698d4b97c2f557c2869a10b11ab5706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4530ad675e9b9fd788e049b5f739fe726bde9afb7e27abe6856098a27a9f448a"
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
