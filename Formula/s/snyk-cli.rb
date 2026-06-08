class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1305.1.tgz"
  sha256 "bf998b19f8e6e405dcd7357288c89bf49a33025ab7a551d6c934b75a23038876"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87b91628dc2b4f99c77106590e92c7598de73e926cba582e88a97ffbb5ea00ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b91628dc2b4f99c77106590e92c7598de73e926cba582e88a97ffbb5ea00ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b91628dc2b4f99c77106590e92c7598de73e926cba582e88a97ffbb5ea00ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "cab66255c724cacd0d7681c234b8102d0082873ad6eb0fe9853f698398e4fc56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6f20424a5ab2c30ba51d2c442221582ad545783da2025bb0b8c5a3109f8ea1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2346ca97de7d128dee8158919f5b128ed5c482121e3cbd910806968db08768d1"
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
