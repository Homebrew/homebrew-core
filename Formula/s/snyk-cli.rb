class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1304.0.tgz"
  sha256 "c623173b0b44e36e507c6c79e2f926392ae9c5ed3497a83fa48ff33fc68aa224"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41c8afcc6d64d3e427f8489df337b59da112d88926ae0698df18b9fc5f09af77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41c8afcc6d64d3e427f8489df337b59da112d88926ae0698df18b9fc5f09af77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c8afcc6d64d3e427f8489df337b59da112d88926ae0698df18b9fc5f09af77"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea8ef185485c02e86cea6d60e5fc7af21d5ce0658f465265883cf7517486fe81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58a6db6b7abc85b5509556b5e0129720a3cf52fa382511fb65e5670b203f7150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae12e5613ef596aa4c58e9633fd04bff0cc0dda3b3009d5ffcb305a1457642b2"
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
