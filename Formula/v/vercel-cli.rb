require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.10.tgz"
  sha256 "3a98fc0704fe283f3ddec193166e56676019bc1c0dcc78551ca20fbf0b718f22"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "487da2ee40c1345b15a5b1242f190abe084f5931b5ec18cfe1c2ecd567c0e503"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d10c025d867dbc651afb9bb85fecf08c9df61606ed47716728a2bdda1994220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27115859844bc68ebcf35bf64b8f173ed40996ca40bcb8600273ead4c6ca394f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae394f699422cdf1a1404e8115dc024775c822c94a02a5482e6672c712854b0e"
    sha256 cellar: :any_skip_relocation, ventura:        "83bac753d82b770257e85f8701b9ce77b17f8aae6dff5eb3fb871e0f0551ce92"
    sha256 cellar: :any_skip_relocation, monterey:       "67e6becbaa467a0170c5c9410643c1b213b84eaf87cd68b309aa21fe9ac04f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e3c8501b271dbd9d84fc2d20c27618a02554cbd4828e2819e12a6f4cbaf5ae"
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
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
