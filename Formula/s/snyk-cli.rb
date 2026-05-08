class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1304.2.tgz"
  sha256 "776f3fd26172b3c0fef4c4fcee191548e2dc5049dbc31403cee8799dc482ebe2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49e6079d3ab2231d888f99680718b6f49b7d27672e20b816df8f7809ed3f521b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49e6079d3ab2231d888f99680718b6f49b7d27672e20b816df8f7809ed3f521b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49e6079d3ab2231d888f99680718b6f49b7d27672e20b816df8f7809ed3f521b"
    sha256 cellar: :any_skip_relocation, sonoma:        "14e2509cc9273066794e4f694c1ef0517b44af23597a5053de4726fbf52c98aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "490d35e845329de42bc5ad50f4eea3284fbae1a9036bcfb182b9fc8ca54aba17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e79abf79c13ffa1a131c1cc98fb3c60c5e8b06f667297cd1f85781d4f6875a"
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
