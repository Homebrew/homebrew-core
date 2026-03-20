class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1303.1.tgz"
  sha256 "ffb3c01f65db01d94ab27e8ac656a8d2f52b5174f776e79e017cf477b13c10cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d8386001350417a23a8427b0367c4ec41086c8809bd9a0383afd2f815324659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d8386001350417a23a8427b0367c4ec41086c8809bd9a0383afd2f815324659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d8386001350417a23a8427b0367c4ec41086c8809bd9a0383afd2f815324659"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b9b7c9be4957b53ec241f76d5d5429eca464688a579244d93779d7495ee33fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c1ef50faf81fe6e921243f8e0a16f0d96ad65c83ef1bb01d468cbb0ce1abcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bad0292a650d7d0860929a16224191fe1034fa8752e444ee124a22ab0793cd31"
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
