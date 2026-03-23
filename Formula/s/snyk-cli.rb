class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1303.2.tgz"
  sha256 "45eedfdeb6a3cf48bb0a57d7bbc04e21fd67af039349615ea097c689134dc94f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3f92e20b98fbd113d116e3b88db70c73072ee239174c57d10fa18892c09c92c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3f92e20b98fbd113d116e3b88db70c73072ee239174c57d10fa18892c09c92c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3f92e20b98fbd113d116e3b88db70c73072ee239174c57d10fa18892c09c92c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c313442a69e1711ce95809212602046b772a6a2e201af4fd6417117cb78ad6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f2a169307afc89d036b4d9464f8bae9ac274451c3b39134054745db1909b786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af1cff85025a0260c7423634df8d2e2f3a5855c386e182e55ebd801360c326fc"
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
