class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.0.1.tgz"
  sha256 "63bd148971b44622e4af2cd926da608c90a926db9683f52e27500d2dbc9cf3a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a9266fccc6d0f80cef31fdb1adf4a01f6551732c25ff46c9e1f2af2c06ca2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a9266fccc6d0f80cef31fdb1adf4a01f6551732c25ff46c9e1f2af2c06ca2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0a9266fccc6d0f80cef31fdb1adf4a01f6551732c25ff46c9e1f2af2c06ca2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e375c9e3b314fa75873781949a459ec02bb58886808533ef0a9ea5464e7fca99"
    sha256 cellar: :any_skip_relocation, ventura:       "e375c9e3b314fa75873781949a459ec02bb58886808533ef0a9ea5464e7fca99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0939368babdebd64301e08831dcaee7bc16485af77e69bcce7e13a2873bd16bc"
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
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
