class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.6.2.tgz"
  sha256 "4ed85bfad5d51ef0086fdd4e8891d1148bfb93afeb146529dac41ff3850c0bc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4aa3e944819079623be82ad4d46cf2a2705e645271cb495d2154bde625ed6c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4aa3e944819079623be82ad4d46cf2a2705e645271cb495d2154bde625ed6c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4aa3e944819079623be82ad4d46cf2a2705e645271cb495d2154bde625ed6c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e13dd78e63eb40838639fa39e314b0e9987f611f0ac386e90f9912281ccd1c0"
    sha256 cellar: :any_skip_relocation, ventura:       "8e13dd78e63eb40838639fa39e314b0e9987f611f0ac386e90f9912281ccd1c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "687ef2ae6c98187ddf7a9b7a3c8c0b1f2dd7b515d27e8bb31ebb059fa264dd1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a72938ee2c27aff89c0d4f44421904651374dc0e3faefd96486730c689bcb6c"
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
