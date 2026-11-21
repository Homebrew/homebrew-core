class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.32.1.tgz"
  sha256 "27c1697419cc80d92c3beb7f84f582b44d6bdc8193de40c25538c69559baa83f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c38348c332d9891a24ba3969d428e3412fb9d410c0f2e15e462c840ce51d5cb3"
    sha256 cellar: :any, arm64_tahoe:       "c38348c332d9891a24ba3969d428e3412fb9d410c0f2e15e462c840ce51d5cb3"
    sha256 cellar: :any, arm64_sequoia:     "c38348c332d9891a24ba3969d428e3412fb9d410c0f2e15e462c840ce51d5cb3"
    sha256 cellar: :any, arm64_linux:       "51c045f00f4b854a88992ffc64989f8d42a1854a2465eb12ab5436d8b599e757"
    sha256 cellar: :any, x86_64_linux:      "07de48afb8f874de0844b2bd673a04ac04c4bb34ff267c0133085686b00287f2"
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
