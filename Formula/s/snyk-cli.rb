class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1306.1.tgz"
  sha256 "102267fa45d81b9afb06afc5b0a98c6c35b4727a4006597ba3120f0d3f8909d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3d54de7a03ddff75cc31f0efbfe9b597f105199643e161a5e5309ebe6962ffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d54de7a03ddff75cc31f0efbfe9b597f105199643e161a5e5309ebe6962ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3d54de7a03ddff75cc31f0efbfe9b597f105199643e161a5e5309ebe6962ffd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f247e2125082a915a1a2dc4dfd1b848f5b87adb6099fc7a89efeb6b03b07e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68c10964239dcc36dc4af812a3b90ebd13976eb40c91c86c7b56e4bdb5dd2a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9563948b4c7fbda8113bb5bc1090fd2295939e1f2063a17f65e6a8074b3c2853"
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
