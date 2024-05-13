require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-34.1.13.tgz"
  sha256 "633c99ebfc63b84166234552cd1c2cd9d5270df2c2e0da2bd4bfc68dce2843f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2506af02f3e8dc1e27e88d30705812e949668083fd894c25ef78e7ca212697d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "323b09ca811c4cc623a40b87765f7c8fe8a839b2a3f118971a46362a410ee527"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac73c54c18190c791a0ecf291ea190a961be94388d31fea69c421301b487135"
    sha256 cellar: :any_skip_relocation, sonoma:         "834de11da17f8f4f5e4deb9892a0b62d0cf8f18d2ae0c98981a2c4afbd35fe38"
    sha256 cellar: :any_skip_relocation, ventura:        "b67962114445a35cfc162b9fe815ec4a7812a7d36103616a7c7d77c33dd69533"
    sha256 cellar: :any_skip_relocation, monterey:       "3021916dfa3b92a684c690a64d1f315f323dfff8daeb1efa476a19f943468881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c957a558831cf912b924672e43f7bc59ca773f1a0379feb40298a0840d912c5"
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
