class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.4.1.tgz"
  sha256 "9a39afd9892438e11d5ff5559cdb1df4cebd676e049b5390e268e36080d74ffb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7530c43aeb47925808419b24acffdfd25a266058b0e052b6db05b1655365c5d0"
    sha256 cellar: :any, arm64_sequoia: "7530c43aeb47925808419b24acffdfd25a266058b0e052b6db05b1655365c5d0"
    sha256 cellar: :any, arm64_sonoma:  "7530c43aeb47925808419b24acffdfd25a266058b0e052b6db05b1655365c5d0"
    sha256 cellar: :any, sonoma:        "4ad3d6363d94ae1dc97fb4b4815afa9188866b895dd9787c07fa08c4eee424b7"
    sha256 cellar: :any, arm64_linux:   "8bdf38be9fef7e3d9090dfda395febae7a53c7cd1fc8ea0471f9fb52e7a79f85"
    sha256 cellar: :any, x86_64_linux:  "95c7f48f64192d21b30b3b998cf7ce2aaa9f87e1803fb41a944244cb825deccc"
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
