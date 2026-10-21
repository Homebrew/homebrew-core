class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1308.1.tgz"
  sha256 "ad7c4d16d4785c4a67869b220d1cc4ca371cfc2afe91c47fa63b51db5c14f579"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9257496f44e5c15fe3f77711292a8b27def9499bc9e77000bd8f80cfc929f5b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9257496f44e5c15fe3f77711292a8b27def9499bc9e77000bd8f80cfc929f5b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9257496f44e5c15fe3f77711292a8b27def9499bc9e77000bd8f80cfc929f5b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f8aaf0ceb97f05d46ffb401b37a6cb679b0495301453fc5f37b6db918485b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "240252717f7fb9970dee29e8d42e3233d96d6a0f8476da7ed55210e794c8c48d"
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
