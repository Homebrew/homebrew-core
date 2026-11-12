class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.28.2.tgz"
  sha256 "af6bb16cbed135077674ed0c65d7b5363427002aff8c0c3028a88cf73d02f67b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d2f09a5b369af50b6e40a45bb67a341a8b5ece1e1dcaf6e6f9e46c8042804a78"
    sha256 cellar: :any, arm64_tahoe:       "d2f09a5b369af50b6e40a45bb67a341a8b5ece1e1dcaf6e6f9e46c8042804a78"
    sha256 cellar: :any, arm64_sequoia:     "d2f09a5b369af50b6e40a45bb67a341a8b5ece1e1dcaf6e6f9e46c8042804a78"
    sha256 cellar: :any, arm64_linux:       "c058980beb39f0831372343a987a701e0f73afee147f013251f8647a66e7d855"
    sha256 cellar: :any, x86_64_linux:      "6e01d052ecfbaafbd6915c6739f9db4a96156f1393770ad3e2a0d0b83da771e2"
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
