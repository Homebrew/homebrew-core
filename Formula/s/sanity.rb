class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.35.0.tgz"
  sha256 "f8b1b3af7a53a69ff85bd4e0e65adc0653b33e63f409df2ce9fab6c7c6196279"
  license "MIT"

  bottle do
    manifest_sha256 "5078b4b9cb6e4f0e992d74ab122f6ac024ebe10c9d84e1e9fdc778c77b2fb95d"
    sha256 cellar: :any, arm64_golden_gate: "fea9a3a298db37fd0b9975eb91ae107d8efe166babf570863ddcd5d7d2fbf7f8"
    sha256 cellar: :any, arm64_tahoe:       "fea9a3a298db37fd0b9975eb91ae107d8efe166babf570863ddcd5d7d2fbf7f8"
    sha256 cellar: :any, arm64_sequoia:     "fea9a3a298db37fd0b9975eb91ae107d8efe166babf570863ddcd5d7d2fbf7f8"
    sha256 cellar: :any, arm64_linux:       "827a8ba3e45667d59bc4696505e558274399e59e02d227325beb29d08af2e4f3"
    sha256 cellar: :any, x86_64_linux:      "37b5b3d29a684a00905ef7136c5786aba2e60e54d2c6a237fe45328497c3d31f"
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
