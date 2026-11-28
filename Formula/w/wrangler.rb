class Wrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.169.0.tgz"
  sha256 "9dd01f3629d7c5411d6fde09ddcc524e262d0d22064a5073f56e42aee562bd79"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    manifest_sha256 "25f74a089fc02f5055ae272cb30c85e73e9411354cdf791324679bd16e475677"
    sha256 cellar: :any, arm64_golden_gate: "3b93c13e7a854a8756f2206a71fa146c21145a17beb6e9bb667e537c3e67da52"
    sha256 cellar: :any, arm64_tahoe:       "3b93c13e7a854a8756f2206a71fa146c21145a17beb6e9bb667e537c3e67da52"
    sha256 cellar: :any, arm64_sequoia:     "3b93c13e7a854a8756f2206a71fa146c21145a17beb6e9bb667e537c3e67da52"
    sha256 cellar: :any, arm64_linux:       "bc9e6948dc5c527c5364b37f6df6a1a4494352636bdb0518c308ce279b0ef057"
    sha256 cellar: :any, x86_64_linux:      "d5b60caa5f76d86d6225d5c72dc55cf32d98fb8f0e19982512e17d6f83975b46"
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
