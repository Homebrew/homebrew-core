class Wrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.168.0.tgz"
  sha256 "ce779983638627326c9e6981eab0795d004eb435dfdaed96dcd9368d1be87335"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    manifest_sha256 "0b29a19d013ba66aa68a133aa395817796b017af50e603cef6b89519fe0f67e7"
    sha256 cellar: :any, arm64_golden_gate: "1ace4e601c58221834e55adb557a128b63c0b00f49a64429423a01ddfc735bfd"
    sha256 cellar: :any, arm64_tahoe:       "1ace4e601c58221834e55adb557a128b63c0b00f49a64429423a01ddfc735bfd"
    sha256 cellar: :any, arm64_sequoia:     "1ace4e601c58221834e55adb557a128b63c0b00f49a64429423a01ddfc735bfd"
    sha256 cellar: :any, arm64_linux:       "fa7d1688ba1c2f3cd8b670ccb67de4c41684e433a97ac61266e65a6a917bcc6c"
    sha256 cellar: :any, x86_64_linux:      "1975fcc8b7f3b2d4cb921221055e908f4c9b7796f7c30cfe51bc43a034196b36"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
