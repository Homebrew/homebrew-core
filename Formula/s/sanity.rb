class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.9.1.tgz"
  sha256 "bd126ca76c0d66cf4946b2078c717b9c97706059d613a71811559d51f8c4434c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9437d86d5262d26c3728545ea7eb05567961372aef21292adc669c27d8bfff0"
    sha256 cellar: :any, arm64_sequoia: "e9437d86d5262d26c3728545ea7eb05567961372aef21292adc669c27d8bfff0"
    sha256 cellar: :any, arm64_sonoma:  "e9437d86d5262d26c3728545ea7eb05567961372aef21292adc669c27d8bfff0"
    sha256 cellar: :any, arm64_linux:   "494fb6e29473201e334d3813311c2aaef715814e445281c5fafe6fa1fda689fa"
    sha256 cellar: :any, x86_64_linux:  "f1b4c48890f0b374c188f2acc7915edc33c99ecdf5f4213f7f9fe7d6b157177f"
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
