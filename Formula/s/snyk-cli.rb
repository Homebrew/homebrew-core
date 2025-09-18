class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1299.0.tgz"
  sha256 "56e678b1e470e62c39a461f4c59eeca7d612279cdbb3163b5e9fefa086786509"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de33397798699313dece6da7fd963f74e268c6cf24c5ffe032e5e4e96e339488"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de33397798699313dece6da7fd963f74e268c6cf24c5ffe032e5e4e96e339488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de33397798699313dece6da7fd963f74e268c6cf24c5ffe032e5e4e96e339488"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de33397798699313dece6da7fd963f74e268c6cf24c5ffe032e5e4e96e339488"
    sha256 cellar: :any_skip_relocation, sonoma:        "97354001cda698d3cb89b055f5579db0d33e9b965de47fec6a3a06bc121b715b"
    sha256 cellar: :any_skip_relocation, ventura:       "97354001cda698d3cb89b055f5579db0d33e9b965de47fec6a3a06bc121b715b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84363709265df0eedb9e357719259c7318d7ad46d01c2f30f7c48fc10330ae63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67d3a5a7efdc4c4463a9e2511b8a4bf5a820205e6195b565a291aed922ddb2b"
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
