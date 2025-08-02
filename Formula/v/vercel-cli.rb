class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-44.7.0.tgz"
  sha256 "1629ba2333d9d7058694085cd09f49ffcfa6ebc5884c81af718eda958e86e8ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7080fa5289a4e0370307c9c4a9127b67c03ff2d78ab6170aba8bc3f066622bdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7080fa5289a4e0370307c9c4a9127b67c03ff2d78ab6170aba8bc3f066622bdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7080fa5289a4e0370307c9c4a9127b67c03ff2d78ab6170aba8bc3f066622bdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "10a2d76d507e06ca0ed447a35676a9905ce8ebc4b20a6b68b50a0cc8bc28e5ce"
    sha256 cellar: :any_skip_relocation, ventura:       "10a2d76d507e06ca0ed447a35676a9905ce8ebc4b20a6b68b50a0cc8bc28e5ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3b6faae70f57a88a792c24898711bfd7cf1a83c1dfeee02c91caa25ab118ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a9097dd9b9a887de5177292a269f9ee3551009ea217958e06043cc30a6c0b3"
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
