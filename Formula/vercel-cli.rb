require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.20.0.tgz"
  sha256 "45a10f124c0c8d0bb80cef4aa613c84d94f7b0675387a8856cc756c2f5675762"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76d72b388f87605a18ca9bfc5484edcc8aadfed62a4778419b00b3ff7a46229c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "872dfdebafcf6c2e29186177012a4ef43d7cfde9aac21874a52e9728921c929d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4529f66ca077dc93e09ec0d6dc0bac0ad875a8207e130fa71fec8c47289da1e1"
    sha256 cellar: :any_skip_relocation, ventura:        "55dbea826dc368ec4cbbeb88b61a1520fb56d31cae47e835ef00b128d2287c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "8db494e1627a85ca89443c950ef41e59b767f46e981c9d5db0886a08f87bb199"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e92c20f60a58a0259464c1cfb0164ad0635bbf1f7333b557840fa9276504551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc1ae312504cc8a3a5bd15de2adb3eda92f3672fe6a8c6f5790f487937c3f66"
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
