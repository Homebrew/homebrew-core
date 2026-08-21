class Woxi < Formula
  desc "Interpreter for a subset of the Wolfram Language"
  homepage "https://github.com/ad-si/Woxi"
  url "https://github.com/ad-si/Woxi/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "227a3712067071454658802d724ace2bee92572d9a371d456f51c480df9e93b6"
  license "AGPL-3.0-or-later"
  head "https://github.com/ad-si/Woxi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "573efbee30cf59899d9c52ee0a27a4f2f5c0407a643228ca07803a49c39e2a10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8bd65ccdf116b4becf2f524ea4ce61f72b3a9b5ba8164595330704ec12f03d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8090b35d77f00ccac550db8e2b0fc0671ab2c0e43d89be5c020e79ee19123e3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "184d0f148115fa5ec0943b56b296355cd857b1cd8600965dfd8946adff560856"
    sha256 cellar: :any,                 arm64_linux:   "072ac24bedd0444706576ed9c68fedf95f041aef3d2723afdf01c3b20a8d78a1"
    sha256 cellar: :any,                 x86_64_linux:  "c9b35676a133464230a2e4d9162cd95413eab709b9da4446738719992547aab3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "woxi", *std_cargo_args
  end

  test do
    assert_equal "3", shell_output("#{bin}/woxi eval 'Plus[1, 2]'").strip
    assert_match version.to_s, shell_output("#{bin}/woxi --version")
  end
end
