class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1297.3.tgz"
  sha256 "034931d85b947f8ce3fce11d40a96a2451da6e0251304be5d7c98c90a02295c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcdb0972441c41855f4bb16f04406ba95c673a4e0c672eec5f2d5eb15f530a51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcdb0972441c41855f4bb16f04406ba95c673a4e0c672eec5f2d5eb15f530a51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcdb0972441c41855f4bb16f04406ba95c673a4e0c672eec5f2d5eb15f530a51"
    sha256 cellar: :any_skip_relocation, sonoma:        "5373b204dcff5e577881a2724b126bce8806fb6ad2bb8d15d79b3beca2f2af70"
    sha256 cellar: :any_skip_relocation, ventura:       "5373b204dcff5e577881a2724b126bce8806fb6ad2bb8d15d79b3beca2f2af70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e38a954b17c85bc91cbc3f48546ae087ec5bf296ba1dc6b8e62a552500b933f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224bfb5e04ff0b37dd4714c554167114e82356f12aec56d9e9b1eddc412591f5"
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
