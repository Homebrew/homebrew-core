class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.2.1.tgz"
  sha256 "0dd6be0804a85b87cde0c243eb1e8428f37b72b3e0f093c734dcd19b03ac9628"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "120551962efadbf5637cf4f0dbbb4d672d627c9a92a56e8c03a91f54048cb983"
    sha256 cellar: :any, arm64_sequoia: "120551962efadbf5637cf4f0dbbb4d672d627c9a92a56e8c03a91f54048cb983"
    sha256 cellar: :any, arm64_sonoma:  "120551962efadbf5637cf4f0dbbb4d672d627c9a92a56e8c03a91f54048cb983"
    sha256 cellar: :any, sonoma:        "5e8da991fe16d6d765413bbb73f409e16f54f6a6fef3d084860b155dd3a1c833"
    sha256 cellar: :any, arm64_linux:   "c829f79c0b77a9f8a121ce2f0a44bc93564a9d1fe7c727cf2539fa7ad9f5b9a6"
    sha256 cellar: :any, x86_64_linux:  "a2d30a66dbcd2662ad9765f0dedffdd4828b0afc61147694d5314e1626ef7ccf"
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
