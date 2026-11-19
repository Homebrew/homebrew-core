class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.31.0.tgz"
  sha256 "a6ef94e0a6f4db7b9cf331fca1208bc3d429eb1798ca32f4e66fca056ac32daf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c6ef0dcff014938e742c99a956f0904be73d6fe0421908ceaa67fc004e03dfd"
    sha256 cellar: :any, arm64_tahoe:       "8c6ef0dcff014938e742c99a956f0904be73d6fe0421908ceaa67fc004e03dfd"
    sha256 cellar: :any, arm64_sequoia:     "8c6ef0dcff014938e742c99a956f0904be73d6fe0421908ceaa67fc004e03dfd"
    sha256 cellar: :any, arm64_linux:       "fa3f418eb6e883c27a58395025a7fa748fc60571e58318efbc40f1aad72b2282"
    sha256 cellar: :any, x86_64_linux:      "679767afb565489375f94902719ba319679436eb1807ca1ba16bff6d640338e0"
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
