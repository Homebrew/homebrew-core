class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1302.0.tgz"
  sha256 "5f69e9328bb97051893eb0106c45776255fffcf850049667e663d86d0efeba2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e55c52fdeb699e3a990f7a1d4d3e49004d8656e042e02524f667d3176210f0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e55c52fdeb699e3a990f7a1d4d3e49004d8656e042e02524f667d3176210f0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e55c52fdeb699e3a990f7a1d4d3e49004d8656e042e02524f667d3176210f0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0e294e7d4def64be0f02b8d65ea997245a537e795708d27fdffb309847adad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0a35d0d1be60d76dfa76bbcb6ed9ff43b7e4b5985422099fe11ba4b54695073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4255e5552327742cdb1854327cade1ba9c757077b0582584e623702aeef43231"
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
