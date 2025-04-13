class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.6.0.tgz"
  sha256 "c41955c82dc5c3d2082e78ee0c5dd0ff2faac58f7a401ed9e1ea2aff4fcf3aa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad6f083e42100bfc5b2fc3d1eb0334d580cfdd29b8b418e7cb01d0ee9a490681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad6f083e42100bfc5b2fc3d1eb0334d580cfdd29b8b418e7cb01d0ee9a490681"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad6f083e42100bfc5b2fc3d1eb0334d580cfdd29b8b418e7cb01d0ee9a490681"
    sha256 cellar: :any_skip_relocation, sonoma:        "326c4f0f20baba66ba519192d17eda6368747539605066fd26786f683bc8eb25"
    sha256 cellar: :any_skip_relocation, ventura:       "326c4f0f20baba66ba519192d17eda6368747539605066fd26786f683bc8eb25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b778c021cfa68d89b210088b28922c9ba45b062defcc40733f9d1b8b009a746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400cb931d3f5bbe401a440a50840d26edb3c6cf36d6ee055c13312ef96b8c14c"
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
