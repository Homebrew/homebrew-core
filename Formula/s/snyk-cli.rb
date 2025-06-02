class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1297.1.tgz"
  sha256 "c522a66b7efd5819679718df5208d1c8d03027aec9672103556a072438ad4ac2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "880af6a59c80099ddd69ce6c256a46c66a676a3da2b54f5f30983fdeae486c32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "880af6a59c80099ddd69ce6c256a46c66a676a3da2b54f5f30983fdeae486c32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "880af6a59c80099ddd69ce6c256a46c66a676a3da2b54f5f30983fdeae486c32"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed2332c274689a03c908c6fe5883ed81977d4066a1b25da0144c55c6d358f09"
    sha256 cellar: :any_skip_relocation, ventura:       "7ed2332c274689a03c908c6fe5883ed81977d4066a1b25da0144c55c6d358f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bde11460cfbface8f236405058a148c4fa73c1d3c10b5c684ec076075db20ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46595927044631a68bc16fab4fe406b4723e994eb54ca1408979518e651712b"
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
