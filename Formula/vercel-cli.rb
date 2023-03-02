require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.11.tgz"
  sha256 "1edd3474021123fbb0c261fe5d4d1cbbc90fc8c3566ea735171e6209ba3333b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d71c29e9b9c52cf95426ca2f8434244f9310b9f71d24d483851db8b9d6e13792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2c4b4cebce7a6808591968f103eb90d133b5ef6af4f99672c0d1e472da45e8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eca3b3675f7c6f046c008f05ec792eddf481265b8595debe2cbc80856d72bace"
    sha256 cellar: :any_skip_relocation, ventura:        "655b3c86c943afe2792b3815fdbdc869526c14171a0439832513da64f84f4818"
    sha256 cellar: :any_skip_relocation, monterey:       "0e5c89393f3fdfaff0c1179fa8014e42261ccc572e06ca9de9a4c3e672ce5365"
    sha256 cellar: :any_skip_relocation, big_sur:        "8acf433b6d96a852fb360fff2c14e3a9ede539063e8d7d6004d9ec08b883c412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d6943459935f47c96efa89674ccd2cdc05eec09dbfe8581cff89a75a7eba899"
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
