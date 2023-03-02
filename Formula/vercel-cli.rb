require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.12.tgz"
  sha256 "b102df0e3041b0b4b05d36c163a2ee21ac4a7bedf3ea81e36c4d0fcc60af684e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45b119b0cf5b8bda8d86626702e04a7e7ec66586c4ce5ff941010368e2aa2299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4460d58b1af976b2743d88cc090ca405eaf558061663a457dcd07831d3ef4c52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52a0cdd169e5b093cd217e203f5d7c6c5eccfa138bc959aa1e0a4efeca85d67"
    sha256 cellar: :any_skip_relocation, ventura:        "c3288b6b587538b2b586da693d55d3520fe229d735aacb57cadd84d3d5635224"
    sha256 cellar: :any_skip_relocation, monterey:       "4a393aeb4f64d42dc503db379ffb87fcf8c7c59b2d520cf4e3e921ba97d90900"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d25b1f9d85e98bfa5aae6ccc1b39f2a146cf688a310443e5d7855aacb099f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66add449b3876dda1eeb9c0d95a229cb2bafbf8abe39b97ddd7f489ed7442818"
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
