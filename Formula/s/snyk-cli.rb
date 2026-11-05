class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1308.4.tgz"
  sha256 "68d1bd8b033fa769700cd912ed576c5cb37cf40f7bf936fdefe865c3f619e507"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa002bee186932e0e81689943052a1b3bd2bcb6fd3f8d0db7e4c2145ee1d8c03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa002bee186932e0e81689943052a1b3bd2bcb6fd3f8d0db7e4c2145ee1d8c03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa002bee186932e0e81689943052a1b3bd2bcb6fd3f8d0db7e4c2145ee1d8c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e874a0e87af94dc4435d1d3ea1c2cc07c855702975c8c8e4fd3ac29c3219e666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fd8bf9fbdfd63dafe4bdaa03bed77aa370d8e787522f6fa92bb4b837b2e0868b"
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
