require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.13.tgz"
  sha256 "6199f66de0c273d15e3ce01c5b4a659d6710a00d4cf3e5267f8bb10d4a8dbb38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e20fa7764a8d8b269b49ed3f116ad8b078d81ae775a9f672baa0bede5e0c0a1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f00822aec60939a932c3278870d386893d9bddc2291441e87045561254eab11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bb2b6ca183ea02d1b5544d50264ef10e84b5146d96bd6adf7480bc556103b09"
    sha256 cellar: :any_skip_relocation, ventura:        "9799d7dc15d1569a9eafcaecc38a6db5d54579e14a9c6df5a3f0ab64a0ef4f10"
    sha256 cellar: :any_skip_relocation, monterey:       "13198d6b76dd8f536753e9b63a78cebd209f0e607862e1479e23082153e311fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1f6ed4bcaee3bf93113e00f537578e2bdd28982ce2ad0b207771fc6407933f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4469b7f3ed8c4662907cbe48f8cc5d8c6920cf2270cd5d8c16dbd423ae04625a"
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
