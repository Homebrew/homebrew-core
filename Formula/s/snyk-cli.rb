class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1307.3.tgz"
  sha256 "9766f1830a10268566ca68e91ec7f939a759d13d6201a1621ee1200be9a537d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a8b0c4a99a3560e318f1adaa545d7adf377186557bffae127fe0b4bdd28c1e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a8b0c4a99a3560e318f1adaa545d7adf377186557bffae127fe0b4bdd28c1e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a8b0c4a99a3560e318f1adaa545d7adf377186557bffae127fe0b4bdd28c1e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5c569810d99177d93d8cca6e2fd4ab265633ef44711c5ab745f047ff65398df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "221f2f753da71acfb4acbd413582b52c8e6b7b15c0e9ca19c3c44355abe02f6e"
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
