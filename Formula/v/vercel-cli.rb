require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.6.1.tgz"
  sha256 "8953686011cff42d1b2564b61a3e3cbfb5f454124852d104b5d75b8281fb991d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19432aac6396ef6390c3331f886a3d4939eb0d6fe13877f1958e0db38cc653df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19432aac6396ef6390c3331f886a3d4939eb0d6fe13877f1958e0db38cc653df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19432aac6396ef6390c3331f886a3d4939eb0d6fe13877f1958e0db38cc653df"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcad8c02cd9b9b68e31b20567caed14daaf97615bfe1bfab18d2d46f99619eb0"
    sha256 cellar: :any_skip_relocation, ventura:        "dcad8c02cd9b9b68e31b20567caed14daaf97615bfe1bfab18d2d46f99619eb0"
    sha256 cellar: :any_skip_relocation, monterey:       "dcad8c02cd9b9b68e31b20567caed14daaf97615bfe1bfab18d2d46f99619eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7248e58a0339eda44a6da50a69c20d3f391de7c1980ecfac8820f95d8f05fd8d"
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
