class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.12.0.tgz"
  sha256 "c936e7ada9618b3baed925aaa693f815ce42ed66172b0f96c1455743174942fc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "372e2d2504463a37d3e3cee7fc820a8bc0e1b13eaaecb7707d81284270f8189b"
    sha256 cellar: :any, arm64_tahoe:       "372e2d2504463a37d3e3cee7fc820a8bc0e1b13eaaecb7707d81284270f8189b"
    sha256 cellar: :any, arm64_sequoia:     "372e2d2504463a37d3e3cee7fc820a8bc0e1b13eaaecb7707d81284270f8189b"
    sha256 cellar: :any, arm64_linux:       "80d35112b563f2164d5aa8b3347b719eb148ada46c409860add0dc14cb37b187"
    sha256 cellar: :any, x86_64_linux:      "c3c4aeddae4c185d0cfb4f3549c72e3a8b3c437955d70898e31fd50129c974bc"
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
