class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.1.4.tgz"
  sha256 "823eff401dda5ea297265e8898272457a8ec004bb9e37918e9d8ec583f43d025"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3f3e0c03979d56d322021ac3bdbf246d4694e394f3ffb1a3776e8a4e07c88eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f3e0c03979d56d322021ac3bdbf246d4694e394f3ffb1a3776e8a4e07c88eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3f3e0c03979d56d322021ac3bdbf246d4694e394f3ffb1a3776e8a4e07c88eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "787230b35281160866001bf0488aa7252ae595ce00ce11e99e68a3392e919aa4"
    sha256 cellar: :any_skip_relocation, ventura:       "787230b35281160866001bf0488aa7252ae595ce00ce11e99e68a3392e919aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adedac6007aced32a959e6d6ebaf9d33980db9c41b618ffc805df42915676eae"
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
