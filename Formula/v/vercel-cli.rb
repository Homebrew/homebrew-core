require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.5.2.tgz"
  sha256 "88bd7bdb702e4d71d382f579d7030fdf2b484f255fdb5c91f59440c1b16e3c0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "426ef622c277321bf7414aa264142d3a4d3c50aac076de7a1380554b928a603e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "426ef622c277321bf7414aa264142d3a4d3c50aac076de7a1380554b928a603e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "426ef622c277321bf7414aa264142d3a4d3c50aac076de7a1380554b928a603e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5967aa1762b6a3530e5aef319eaaa9b5cc2477ce2f62500d454982d6be2dcc6d"
    sha256 cellar: :any_skip_relocation, ventura:        "5967aa1762b6a3530e5aef319eaaa9b5cc2477ce2f62500d454982d6be2dcc6d"
    sha256 cellar: :any_skip_relocation, monterey:       "5967aa1762b6a3530e5aef319eaaa9b5cc2477ce2f62500d454982d6be2dcc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0725e7312933677de9f21b621480e8b2efba838294014cc77b3bdcd983d36373"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
