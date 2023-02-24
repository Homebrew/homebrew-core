require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.7.tgz"
  sha256 "7e7b336c42080fd5b3b073edafa91e607afde23fecb017aa71b4a09a6044f320"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa9bb19301cee3569a66357acf325a402520a0967d77991497bb258072ae8c6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b114fca4daadee70b4f905a37f75da8bbcb086d2449570872582e6392f9dc8ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e54b0a9147e0f07760124eacdedaacab487ba45be79a5458dba702fdd124a653"
    sha256 cellar: :any_skip_relocation, ventura:        "34fb6bea72e1892a336441910dc7709c68f6077b6de7e6509cdef73dd2008d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "2382339de3277851e7e3220918590c77d4c359b8cc860812a5fa9e2fa91ae86f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e77635f7ca857f19300ee9e3076329e624d6fc71768adb93436bb6870f1e282f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adb1aed389721927d264cf4da80e836242c3258ad933ffdde4bb70d4d1aa6b27"
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
