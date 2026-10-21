class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.21.0.tgz"
  sha256 "8c18aeddf5a0876387b1011b4784712032e71a5292eebdb8c8f20b4fd2f51432"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "920549a3974597cd06106a7426e78efbb2d6aa6175a6a6d3cbebd05bc4aeeecd"
    sha256 cellar: :any, arm64_tahoe:       "920549a3974597cd06106a7426e78efbb2d6aa6175a6a6d3cbebd05bc4aeeecd"
    sha256 cellar: :any, arm64_sequoia:     "920549a3974597cd06106a7426e78efbb2d6aa6175a6a6d3cbebd05bc4aeeecd"
    sha256 cellar: :any, arm64_linux:       "95b5f598485b2e2892559456d2fcdd4eb27b5b16f5e3e9cc3026ba3920b55a42"
    sha256 cellar: :any, x86_64_linux:      "5d7abacd1bb8aa06c92ae8a3a46675762a865a32cfffcec33360ea0c00bdea3b"
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
