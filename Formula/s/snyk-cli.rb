class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1309.0.tgz"
  sha256 "2a03d3725763169b64a6c994fa1a3ba3e163231634fe26a1d0873c6b5e193673"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "27cc6750ef65a2bab8ad0f7792ccba16ddb956afb9d2e454107716d8d3de890e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adb74219266eb2076f73e9b81964e58ceae5fde504f794c3f7a17b2673c593e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "adb74219266eb2076f73e9b81964e58ceae5fde504f794c3f7a17b2673c593e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "adb74219266eb2076f73e9b81964e58ceae5fde504f794c3f7a17b2673c593e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "758e8dc9f8a99b6affa90a011233ee39ed8e82831e27413282cea55d4876c8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ded6fa4640dcb910689c03288b4f30e4e0f03750d9fbf6a65272d26bed8514c7"
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
