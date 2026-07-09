class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1305.2.tgz"
  sha256 "2299a22e29e9222c827811d9446c06647deba1e282d5e51aed2546a48795c37e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be017f536cb372eb89ac4b85548179b214b15842928fd6de07ff50cd0a2ad763"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be017f536cb372eb89ac4b85548179b214b15842928fd6de07ff50cd0a2ad763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be017f536cb372eb89ac4b85548179b214b15842928fd6de07ff50cd0a2ad763"
    sha256 cellar: :any_skip_relocation, sonoma:        "55d6125eccf804cb0f919db109f6406a606aede64f39c8ce9bebf522459cc938"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a33c2d7ab5f9083d457ea9ea33e3cba4a6d25d5c5e5fe894a6f4482d5e5f03d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d69fd44c200f5256134ad6e80350d67cfc2f7c9c091139c52c4bd0deed41836"
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
