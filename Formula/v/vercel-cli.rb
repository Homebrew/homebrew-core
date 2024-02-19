require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.5.1.tgz"
  sha256 "07c0430f94a931e38665503ee5fe694029e560a758cb518ca0ea1b1c441075a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "081eef7b1f52ea7e8320925ea49103c2ba0ae1ef5c7997ac396d05d1dee392f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "081eef7b1f52ea7e8320925ea49103c2ba0ae1ef5c7997ac396d05d1dee392f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081eef7b1f52ea7e8320925ea49103c2ba0ae1ef5c7997ac396d05d1dee392f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7274d44b3850011f6b6addd7b56b341f004bc3c7669488b69ec574c8d147983"
    sha256 cellar: :any_skip_relocation, ventura:        "e7274d44b3850011f6b6addd7b56b341f004bc3c7669488b69ec574c8d147983"
    sha256 cellar: :any_skip_relocation, monterey:       "e7274d44b3850011f6b6addd7b56b341f004bc3c7669488b69ec574c8d147983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7dbf929f7922f6dd90bef5e8fc71c4d99c814a617d11d37e810a14afa797b6f"
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

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
