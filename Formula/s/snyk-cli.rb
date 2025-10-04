class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1299.1.tgz"
  sha256 "9785b452560f457ac469d6df76a8044b9a83bb1b3e8150d3c1d4a8952cf53f3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d833423cb45b1550840dafbc4b073581535a1ca8122c2601ae263831ba1302a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d833423cb45b1550840dafbc4b073581535a1ca8122c2601ae263831ba1302a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d833423cb45b1550840dafbc4b073581535a1ca8122c2601ae263831ba1302a"
    sha256 cellar: :any_skip_relocation, sonoma:        "34e6f72191e229e6c9158c580f91e1cfeebfad81a3282b14265768ea709d5f1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28020c3a2ea5120343aa1213bfce34d77f87c0be07b37e554418b0840df43bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b5910a9c99a75b36c8e82d2ea6d679b393a9e615a93cfdbd28e4b321a0f4db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86-64 ELF binaries on incompatible platforms
    # TODO: Check if these should be built from source
    rm(libexec.glob("lib/node_modules/snyk/dist/cli/*.node")) if !OS.linux? || !Hardware::CPU.intel?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end
