class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1304.3.tgz"
  sha256 "8b3ba600c5f891a74d45d8e0945a3d194df9df2df4a327c2076d0be970a3fd9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01ce57f4904cc03547c3612e919545cb1374eff293f24d9a17ae2b3d00430592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ce57f4904cc03547c3612e919545cb1374eff293f24d9a17ae2b3d00430592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ce57f4904cc03547c3612e919545cb1374eff293f24d9a17ae2b3d00430592"
    sha256 cellar: :any_skip_relocation, sonoma:        "13f702dde020cc24fcd6362fc4bee644ad230d90a751a5ec5d53ecd3da48ed69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92b4c6f16140a3f4fbbaf0062ba1e4d1bf9246ac062a59025a3a660452f21223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430492bc8a91aa97cb43edd0de5044b1719bae26b729e827aaddc4386083e813"
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
