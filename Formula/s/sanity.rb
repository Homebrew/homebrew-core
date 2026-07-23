class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.12.1.tgz"
  sha256 "d490c4a8c81c7686d56e2b83cfe1b9d131516066b0912cd31673f6e16024152f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9a4a4e3abda1f7f34e6c7a8c0a97e4de5f544f488a179804eb50c0c9e5a4a509"
    sha256 cellar: :any, arm64_sequoia: "9a4a4e3abda1f7f34e6c7a8c0a97e4de5f544f488a179804eb50c0c9e5a4a509"
    sha256 cellar: :any, arm64_sonoma:  "9a4a4e3abda1f7f34e6c7a8c0a97e4de5f544f488a179804eb50c0c9e5a4a509"
    sha256 cellar: :any, sonoma:        "cd362ef70b8943455297f922700dba887b2f4c2fa61ed361a2c69632c2aee467"
    sha256 cellar: :any, arm64_linux:   "6119f4da36cf6ae182310ddf66c906dd2d72357b7baf37eab18e5ed521f57efb"
    sha256 cellar: :any, x86_64_linux:  "3392f14e1459283193e358aacc4dcef3b5a57c89d8d9f4f9cd4467eea8dda503"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end
