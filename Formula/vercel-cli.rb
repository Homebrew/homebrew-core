require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-30.2.2.tgz"
  sha256 "b37bce119a64283619018905726850e31a303dd61edcbce39bdde91b303a6198"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3bf22b5a42f6ae42e0b2adbef9c8b5d9857bbfad015eb6ffadeddbdaff21cbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb6dba4d5eaeb2c188df4a6c0a66b5666362cbd14497cc5cef80cb9f10f2a4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8db7be3e27e743191cb2b229ac66abee6d1749219b67255790191585e465323"
    sha256 cellar: :any_skip_relocation, ventura:        "ad3a2007f041e47c908cb39fc47267ecee68e6e08d45b3650d81c49283884c0c"
    sha256 cellar: :any_skip_relocation, monterey:       "0e3f3bf5c78c343744a08f52c3f6ed23a6752fed69a496cd234f9857e4f31a50"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ccc2552719442d7e968d0c2af1c488fb9bb6aa6721cca55ca9c5c8b5cb42d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e915d2aefe7785d949b0ca79c822bd9be2f699acd63d6d190edb6123d8bd5d6"
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
