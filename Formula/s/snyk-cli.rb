class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1308.4.tgz"
  sha256 "68d1bd8b033fa769700cd912ed576c5cb37cf40f7bf936fdefe865c3f619e507"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b1dd0eef6f1b0331ab65a55a7cce61c335c4bd19924495517c1d2e28f0e5a35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b1dd0eef6f1b0331ab65a55a7cce61c335c4bd19924495517c1d2e28f0e5a35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b1dd0eef6f1b0331ab65a55a7cce61c335c4bd19924495517c1d2e28f0e5a35"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3d0e36f7c36452d535b5738dacb062c31da79320be12570a03b0d4d9c4cff38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4499c419effb89c31ffb5654b0aad793ec6643ffa7001a1933ee7adc70803f2c"
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
