require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.3.tgz"
  sha256 "e18e638c9238cdb022605e2153f091131df7b16a93a0c862676c3b8705ef745b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8a12d1d4ddcd10aabcae2f0092450f710c955a3bf8ac56d0b1738e969d6b3c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9161a099371d352c2ee900053dd299698512281a9014f093bc9e1de67c6a6de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78cee33dee099d86073ecb66ec7a235f9c7b4e5ff6e44381d193d4b6600f54a2"
    sha256 cellar: :any_skip_relocation, ventura:        "459ab5600a0017402e51a3d0c1d81b6679c16cabf5015ca819ba26460738b488"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1060788fd943c5d0651e77b278c9ccbeea9eb08717e29ba1a9be2217a78d16"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fb60ffa987017c61655b6fb1f06a2feea0ec553e14b9497f117834e8c012eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04f06f426be0255e3ec5956cd83ae71edf0bef8410e7d2428b5789e99441bbb"
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
