class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1296.2.tgz"
  sha256 "9a9bdb1e44a7e5006925b77c3ef63827aface2cb3248684f9ec7e119b25c33cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c62dbe503cf495199acfa3323ac47a4a68ab0b0d940d5dabdb19affa17da26ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c62dbe503cf495199acfa3323ac47a4a68ab0b0d940d5dabdb19affa17da26ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c62dbe503cf495199acfa3323ac47a4a68ab0b0d940d5dabdb19affa17da26ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "707e91ecbaca87942042e7e2dee4e267525c87066bde87333105048ae27acd6d"
    sha256 cellar: :any_skip_relocation, ventura:       "707e91ecbaca87942042e7e2dee4e267525c87066bde87333105048ae27acd6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a772a090139f79f18c8a5692a3e206bce88b7b87f708bcec89252659c543983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e567604edab9a1991df8ab0e75ee327ac240b86a5b2f122aeefa4d0df9a793c5"
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
