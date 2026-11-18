class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.30.0.tgz"
  sha256 "b62b70c58b10eae5019764e4092fc70fd526cd06841fb1e0d7a796556950b3a0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "386aee0ac6d5efdad7f45bf1c9f79a1f6cbbd05f872e801ff199675d2da385a9"
    sha256 cellar: :any, arm64_tahoe:       "386aee0ac6d5efdad7f45bf1c9f79a1f6cbbd05f872e801ff199675d2da385a9"
    sha256 cellar: :any, arm64_sequoia:     "386aee0ac6d5efdad7f45bf1c9f79a1f6cbbd05f872e801ff199675d2da385a9"
    sha256 cellar: :any, arm64_linux:       "91fbe9cdf6f7ba19f82df80b84a7f3a9d7becb19622dfe3994768d44084bccb1"
    sha256 cellar: :any, x86_64_linux:      "6798573c1b58aa54424c5f87e0b1acaf675afaf56ee4becc4182a5a1376cb78c"
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
