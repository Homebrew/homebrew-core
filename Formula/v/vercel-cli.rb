require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-33.6.0.tgz"
  sha256 "6ab49a0822549e22fd18a7006c2d443b08a6ee9c91ea1a1e0cdb25ca412447e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc4703aeaa525ae292af9db9cd92a63ed7875eff99e127da5c622a446e5a6cbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc4703aeaa525ae292af9db9cd92a63ed7875eff99e127da5c622a446e5a6cbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc4703aeaa525ae292af9db9cd92a63ed7875eff99e127da5c622a446e5a6cbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c95a7e5d36bc4608f07a70af4b694b4fdcb2cfab7a355af96f597d8ebbc6451"
    sha256 cellar: :any_skip_relocation, ventura:        "8c95a7e5d36bc4608f07a70af4b694b4fdcb2cfab7a355af96f597d8ebbc6451"
    sha256 cellar: :any_skip_relocation, monterey:       "8c95a7e5d36bc4608f07a70af4b694b4fdcb2cfab7a355af96f597d8ebbc6451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df0834fb2eee5f5a990823720d702f14dd898a01e387e757a42af4ed9dc6b8de"
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
