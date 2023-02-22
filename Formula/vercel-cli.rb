require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.4.tgz"
  sha256 "da7581d1c71f78f900b0818b2c1b9889476490bf1e359391504b94092861b2e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eb2688e7b6fd2cfd9b85642aecbd47191b8c2c05f4a231dce222d82881530ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be1f4df75e66241ac49af26e1b7ecbcc35bcaa45616a9fe7d5ca9aac5ee198c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d84b249a018cce77c350d6b42791e0113f5da3bf69153cae58e3cdd242f10f4"
    sha256 cellar: :any_skip_relocation, ventura:        "46b2ec48b553fa6098d8380dd30d71291d97c30e4b58214e37a81754d991b2e9"
    sha256 cellar: :any_skip_relocation, monterey:       "2ece4247ca2955da1c9720c5688ae5df86e7e5721ff2b906158ceddd22975ac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a75a355ad5842d8816803678ddc6da72ce6a9997cba68d9a40aa398ff4ebedf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abfec068f2ec8e4e5b8d65c4af6125ad0764eb3fc676bfc59fbe09854d49510d"
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
