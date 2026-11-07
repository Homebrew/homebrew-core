class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.28.0.tgz"
  sha256 "0211fd7f08c69aa152611ab215d70a88c16bd05e7722ea50b93d65916d7cc27c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f2fa42131cafe6e0ab31d6d4be0b51247cc18fce72566aee8b34b5d4ecc45952"
    sha256 cellar: :any, arm64_tahoe:       "f2fa42131cafe6e0ab31d6d4be0b51247cc18fce72566aee8b34b5d4ecc45952"
    sha256 cellar: :any, arm64_sequoia:     "f2fa42131cafe6e0ab31d6d4be0b51247cc18fce72566aee8b34b5d4ecc45952"
    sha256 cellar: :any, arm64_linux:       "d4a602d0e2b84d1a2e94ff818635983df0faad5cd48e3e55463140b2c1a8306e"
    sha256 cellar: :any, x86_64_linux:      "9f60d52e20b3849366be5c5e7c89e0c04d7c8c759ee1bbbc32b29153cba2d391"
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
