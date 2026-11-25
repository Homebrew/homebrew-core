class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.35.0.tgz"
  sha256 "f8b1b3af7a53a69ff85bd4e0e65adc0653b33e63f409df2ce9fab6c7c6196279"
  license "MIT"

  bottle do
    manifest_sha256 "1713fcae69e430172444f23fd0f71e4712c06ec1f47832bb6d5e533ede803f7d"
    sha256 cellar: :any, arm64_golden_gate: "ed3b954897f4cd0a15e4aef537708cff8bfdd6ac4e2055d8efa36bd8056f24a5"
    sha256 cellar: :any, arm64_tahoe:       "ed3b954897f4cd0a15e4aef537708cff8bfdd6ac4e2055d8efa36bd8056f24a5"
    sha256 cellar: :any, arm64_sequoia:     "ed3b954897f4cd0a15e4aef537708cff8bfdd6ac4e2055d8efa36bd8056f24a5"
    sha256 cellar: :any, arm64_linux:       "e498b04051cb8f89739a8e59c02f42e8599340fddf2a59463d4ac1c1e211d831"
    sha256 cellar: :any, x86_64_linux:      "ba4e5df695b812151653867be6edccdd2acb475ddd85afa61110801524f0aa5e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-buffer,bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
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
