class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-42.2.0.tgz"
  sha256 "8bcf291e9dedd98f8728c3c2fc74f3016e100f22b3a5108fb438f05b68e5a5c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2e393aa97395abb09509c0f1c02da1f824d17800c7928076e8fbff99bf71e62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2e393aa97395abb09509c0f1c02da1f824d17800c7928076e8fbff99bf71e62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2e393aa97395abb09509c0f1c02da1f824d17800c7928076e8fbff99bf71e62"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e931cd4af13dc361ac5d3db6e30ae7d88399233198cc115c163c248a3236b4"
    sha256 cellar: :any_skip_relocation, ventura:       "f1e931cd4af13dc361ac5d3db6e30ae7d88399233198cc115c163c248a3236b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eac010d10d49d62f795dd0d3cdc80deb98c94b3dbd4ed2be23701fda28867f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "918440b4e2c0c27d1e07a7af1d5d3c49367488f04dfdeb981dc884d32ce47516"
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
