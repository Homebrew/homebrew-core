class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.0.2.tgz"
  sha256 "bdb77d52f5fb8e27ad9120ff4be4860d2db82f3181bbb351131d49cf11b4d6a8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1cc46499eb8991d5ace56263df5c0a63f83f78a76e9dce195f738ea6ed42c948"
    sha256 cellar: :any, arm64_sequoia: "6417b0977f935a723be4bf78044c1d4263fc8c4eda38ee2e6e2d3ac7938981f7"
    sha256 cellar: :any, arm64_sonoma:  "6417b0977f935a723be4bf78044c1d4263fc8c4eda38ee2e6e2d3ac7938981f7"
    sha256 cellar: :any, sonoma:        "bcbe095fdb99bc229a0d6aecca1b9fc8d72f27b669cfed92ce5e01ae51f7aec3"
    sha256 cellar: :any, arm64_linux:   "6f1a7b77f19112abf1ed74cf953128394cd7d2d58d89faf5ca4c1f9cd4e60ac7"
    sha256 cellar: :any, x86_64_linux:  "4d872b4caf53d4d90075cba2dbe9aa53a1a25dd74a19dc8c9f249c5ab2cb95c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
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
