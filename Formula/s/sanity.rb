class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.7.0.tgz"
  sha256 "d775775292aa6f85dbeb4f519cb8dbb43e236d22306371d6e55d3d4bd6b52750"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "09b3c049bf8abfd6d7d6d941fbda045328d94b5149f2ebddb4dc24dfae9e21b9"
    sha256 cellar: :any, arm64_sequoia: "614dd3a48b3ca3b7999feede4a7bb6674064495bbee15f43556450dfac775201"
    sha256 cellar: :any, arm64_sonoma:  "614dd3a48b3ca3b7999feede4a7bb6674064495bbee15f43556450dfac775201"
    sha256 cellar: :any, sonoma:        "56e65690884ea7a140af1860ad415ef8e504a03d5b61336f4c586df8b78ad322"
    sha256 cellar: :any, arm64_linux:   "32ccaeec0a7672e5dd4764285a2d364b8ae3e61954f0e22562be60815cd8fec7"
    sha256 cellar: :any, x86_64_linux:  "ca8bc82c8f51498ebe7dfd96dc952aef9b6e315bda01246fec85df6637abe33e"
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
