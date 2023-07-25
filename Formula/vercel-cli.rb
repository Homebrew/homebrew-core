require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-31.1.0.tgz"
  sha256 "3f640edffbf3bd91a8a864af59298bf32875fbf461b8665d5b6427441d9902a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "789924fb429728f28092a74fdd948bb0b130cf731cd9e7c415f85e508f8520d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1a57eb085ba39211be240ff63b52e02cc6c510a0a1549a53d9a269a09d6b5cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b4e0194e3f01b6e0f47935bd7b1149b6cd407a9dea96cefae3880bf86970e1c"
    sha256 cellar: :any_skip_relocation, ventura:        "0af0127ed07e6be1f206c8454b032a9d7b34af3256a3643f23cba6e83479dd5f"
    sha256 cellar: :any_skip_relocation, monterey:       "6628bcd7cb8a00a69712d1355d15aa9ba5648c08deab12221b6cd1d7e1fd09a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b3987d1d37853ec5789a63884be6a851539cda02af31697fad155ad9fd16f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b5e8873c57dd7ede822895c5e75c2e76242029afb30044049fa9f1264ecc3a"
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
