class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1301.0.tgz"
  sha256 "635aca1e076ec601529681fc6dd859df626d7efcf7e372a698a8c9ee26ce716b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d77126ec1341900a19651f4a3b6065f3629af21634ff2614d084e1f8109fc16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d77126ec1341900a19651f4a3b6065f3629af21634ff2614d084e1f8109fc16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d77126ec1341900a19651f4a3b6065f3629af21634ff2614d084e1f8109fc16"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cebfc05cdfd5c9a9dd7cb612f4e6e4598524d75832709e30eb1c7743154d629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a1d8a475cba9f0b6adaa09deeacb1177996596a24c23cbfe16f264f671ce78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70fd0226c3ae4c80fe611e10ccc21d8968c76c5c234bbf3e66a095cceae40cd2"
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
