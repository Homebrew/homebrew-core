require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.5.4.tgz"
  sha256 "8943682385fc825f5b1053aa94eb38dbed7634208448ef7647a95b670db4368c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d1a6bb1d9bd0a4f90315f9a85e9e90ffd222f3f324750466722fdb6b8a0dc07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d1a6bb1d9bd0a4f90315f9a85e9e90ffd222f3f324750466722fdb6b8a0dc07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d1a6bb1d9bd0a4f90315f9a85e9e90ffd222f3f324750466722fdb6b8a0dc07"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c22d868bca2a34604423e0ed516a42614237d27479d2bed08b7f37e3434bcd4"
    sha256 cellar: :any_skip_relocation, ventura:        "8c22d868bca2a34604423e0ed516a42614237d27479d2bed08b7f37e3434bcd4"
    sha256 cellar: :any_skip_relocation, monterey:       "8c22d868bca2a34604423e0ed516a42614237d27479d2bed08b7f37e3434bcd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd943664dada5a8533e57c017671265548cb1e3da5e046fd3cad74b102ca6ddf"
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
