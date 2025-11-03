class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.8.2.tgz"
  sha256 "927f7091ed2583cd75ca183646f6250a0c201b5702e1a7c1462bbd8227599f67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e34266c9a05d925d0109a1994e51facf7f7ba489cbb77e01a21c0080135cbed0"
    sha256 cellar: :any,                 arm64_sequoia: "01d38ce64dd94c63358de9f18e0d8657c57874a2f75099cfb338173d1aeceb66"
    sha256 cellar: :any,                 arm64_sonoma:  "01d38ce64dd94c63358de9f18e0d8657c57874a2f75099cfb338173d1aeceb66"
    sha256 cellar: :any,                 sonoma:        "b4043b0f5520a648812ae4952a8a40e62783cce44fa62e316fa22cb64e14ae89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcdb10f5e61f25bd3e30cf48d3a005d4d7353a1c87ceb6109034f6d8bf45d820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b00463ff2930c120136abb165655bbab29cd24197e3d0cb27c38a0040570fe"
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
