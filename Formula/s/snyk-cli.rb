class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1306.4.tgz"
  sha256 "47bc19e4d2b64a786e554ad068859e4fda99732231cf2136431f8182359baf7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb02f29a851ef11379de0a56f7529f0e3a328689f8be0996ff423978330624c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb02f29a851ef11379de0a56f7529f0e3a328689f8be0996ff423978330624c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb02f29a851ef11379de0a56f7529f0e3a328689f8be0996ff423978330624c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b30f673d0f936e48249ba3b4caee0b2796ac40ab59b0772d0f5de1fda0d2fec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e09bb4054cfa347d0e56169e3e2d0fb11bc331ae5fc17e58ea56a361b5dd999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc5c8c74a6e28ece0f23e85adf6ca6622e0fc0cac6f891a0c8e258933deed1b1"
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
