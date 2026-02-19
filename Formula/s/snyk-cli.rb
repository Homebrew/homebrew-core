class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1302.1.tgz"
  sha256 "c64b4dc401033da81adfeaaf85f3be28cdbf0851f28fd124c3c916a986f712f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b2fb17b7472ef223d81a168a408b95acb02a6e238acf41da6447380791de058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2fb17b7472ef223d81a168a408b95acb02a6e238acf41da6447380791de058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b2fb17b7472ef223d81a168a408b95acb02a6e238acf41da6447380791de058"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d6502c80cc29e9655081d34c39d57748aa277d7d1e1ee6f6ecc447b9907950a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac62fb2410e12cf3caf573daa6ef40099123201e0ebee3e007d78753d5489b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de3c8c18deff1d8d478d524df2387fa64a4447e8074a6ac04d3e8d5e34122f1f"
  end

  depends_on "node"

  def install
    # Highly dependents on npm scripts to install wrapper bin files
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

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
