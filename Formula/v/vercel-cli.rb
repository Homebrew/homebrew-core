require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.1.0.tgz"
  sha256 "862cce0a732d2e90371e280dcd8f21df2d5d904719c62ee86cc434de731dfe31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f66ba0d67e92b07edb311c3d56d4423779d585a4cf35fa689b30caf56111253a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f66ba0d67e92b07edb311c3d56d4423779d585a4cf35fa689b30caf56111253a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f66ba0d67e92b07edb311c3d56d4423779d585a4cf35fa689b30caf56111253a"
    sha256 cellar: :any_skip_relocation, ventura:        "484cafb358fb207cd2de3f7167175f8a6cb52ff43d3dfdf73e85b8c8d21b40d1"
    sha256 cellar: :any_skip_relocation, monterey:       "484cafb358fb207cd2de3f7167175f8a6cb52ff43d3dfdf73e85b8c8d21b40d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "484cafb358fb207cd2de3f7167175f8a6cb52ff43d3dfdf73e85b8c8d21b40d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82d61515a5be7f39467a09f5917a6d2edc69e7eb07684558d565cfc8bee6eb50"
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
