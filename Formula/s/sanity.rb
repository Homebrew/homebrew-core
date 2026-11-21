class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.33.0.tgz"
  sha256 "7fbaed346cbceeb88a60e093e62c2a455bf55500bb1c0ae11fa3113c9c7f9fec"
  license "MIT"

  bottle do
    manifest_sha256 "79fd1e636b897d0e5ab2d1653bd749377fc6c966d3caddbe765b87fd29c98bfc"
    sha256 cellar: :any, arm64_golden_gate: "4ccf777f5d4c22979376c920fcbc4422d503791b787ad8cb1139354067f409ad"
    sha256 cellar: :any, arm64_tahoe:       "4ccf777f5d4c22979376c920fcbc4422d503791b787ad8cb1139354067f409ad"
    sha256 cellar: :any, arm64_sequoia:     "4ccf777f5d4c22979376c920fcbc4422d503791b787ad8cb1139354067f409ad"
    sha256 cellar: :any, arm64_linux:       "ac169b677dcab958cc2a2866d0cf41aea725e596cf52ad03e24728f6621767a1"
    sha256 cellar: :any, x86_64_linux:      "1568faa918a8c40b8e6126491ba995d263407241238f29375933494eed217512"
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
