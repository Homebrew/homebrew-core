class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.29.0.tgz"
  sha256 "71fb8a215c24fb2879e066872129dab6077f5476c64fd585e9f046fd3c5408da"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8b4b7187d0b17931222a30eb463e20ea101e795ba1ef22f45ed880dad4003f1f"
    sha256 cellar: :any, arm64_tahoe:       "8b4b7187d0b17931222a30eb463e20ea101e795ba1ef22f45ed880dad4003f1f"
    sha256 cellar: :any, arm64_sequoia:     "8b4b7187d0b17931222a30eb463e20ea101e795ba1ef22f45ed880dad4003f1f"
    sha256 cellar: :any, arm64_linux:       "51da5de277efdbf25891b1e0e8d6b34911450f6895112eac363c06b702c8234a"
    sha256 cellar: :any, x86_64_linux:      "1553d18ce02dcd43eb804abe2a6bb78d560afd3f6d440df292e4760188be20b0"
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
