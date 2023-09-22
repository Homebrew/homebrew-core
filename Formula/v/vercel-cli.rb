require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.3.0.tgz"
  sha256 "1161cf40036742f3b1ae35404dbc6a69788b3ddf48c090620fdf526c6ca1aebb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f0a6cb2dba883d8dee2e1bb725bec91d72d3e9dc74996754515846f7556d08d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f0a6cb2dba883d8dee2e1bb725bec91d72d3e9dc74996754515846f7556d08d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f0a6cb2dba883d8dee2e1bb725bec91d72d3e9dc74996754515846f7556d08d"
    sha256 cellar: :any_skip_relocation, ventura:        "4210e538eabab6c084104a4bf707d0238c78c616315fcc20fb2a21294017303e"
    sha256 cellar: :any_skip_relocation, monterey:       "4210e538eabab6c084104a4bf707d0238c78c616315fcc20fb2a21294017303e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4210e538eabab6c084104a4bf707d0238c78c616315fcc20fb2a21294017303e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779f9f9bcf15edce6d0993d51cdd63a5983cd3a197dc41c1d8a1ae326a6a9f7b"
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
