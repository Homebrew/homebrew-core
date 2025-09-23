class Svls < Formula
  desc "SystemVerilog language server"
  homepage "https://github.com/dalance/svls"
  url "https://github.com/dalance/svls/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "7261f2baf8169146d21b88a8339f161f51a8b8a57982a96aaa8b9dc5402fc1de"
  license "MIT"
  head "https://github.com/dalance/svls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aa60524a14a95a07d297475c22f6a94770475e0405765b19217c280960bd823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10be4eb74761995e59e60ea16000a4a44bd69e64d55aaa7b0c38db5d0c5d9436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f403608e739a9129585a1f9ae5ebd9d57889e45ee394888bd5cfd8b2f7381dc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d8dc214a4fc8958c09e097d85d7fe262bb77b5865ad71ddc78ffb07ce84c798"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2a4899bd432c1e4ab65138eea8d3383fd5948037700fd5288dafd7e9da527d7"
    sha256 cellar: :any_skip_relocation, ventura:       "d4a04bc8858c53e1c78cabfcfc0762244fe7a6efd730f0f55fd9528dfd083d7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "115bab944b9b46fe63d7380684c57c9dd9107dc913e33cfd2e468e7bb0d634e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "145d9a79f2bfcf2d543835ec7705aa6aeed8191120b04dd492201c23af3f6f47"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = /^Content-Length: \d+\s*$/
    assert_match output, pipe_output(bin/"svls", "\r\n")
  end
end
