class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.28.0.tgz"
  sha256 "0211fd7f08c69aa152611ab215d70a88c16bd05e7722ea50b93d65916d7cc27c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "25f0e5ea9137a156476ef371f450c7ae345f6c359e71b5b0ec8ced7fd81becdb"
    sha256 cellar: :any, arm64_tahoe:       "25f0e5ea9137a156476ef371f450c7ae345f6c359e71b5b0ec8ced7fd81becdb"
    sha256 cellar: :any, arm64_sequoia:     "25f0e5ea9137a156476ef371f450c7ae345f6c359e71b5b0ec8ced7fd81becdb"
    sha256 cellar: :any, arm64_linux:       "8b310e3654c04ff7b0ca0a8b4937fa1ccf8a1e8549e661c7638a186c4a5ca6c1"
    sha256 cellar: :any, x86_64_linux:      "8050d4198c7d53224f4d43d961768be20e1d9e123bdda5fa797a87ee16216d09"
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
