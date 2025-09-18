class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-48.0.3.tgz"
  sha256 "0294b779bd61276f2339446a6e7fc7e89cb32d46cf45146b9f51b28615681c56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "400dfa71a0dfcb6bcf8fc9ae02f0de439842c5623375a367d541a8152651e177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "400dfa71a0dfcb6bcf8fc9ae02f0de439842c5623375a367d541a8152651e177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "400dfa71a0dfcb6bcf8fc9ae02f0de439842c5623375a367d541a8152651e177"
    sha256 cellar: :any_skip_relocation, sonoma:        "edf7efc0781ad6faf8b621fafbd6af1d9f802bd538e9345706e08e6eed21b5a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5a857ef5f1dedaa6a329c7f2e4fd83e36fb2c43d3ac31869d93fcf85b07545f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff433e0c655a5266a56eeb18a2776ca8daeb5c47e07af2de56f1e93575ac8b29"
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
