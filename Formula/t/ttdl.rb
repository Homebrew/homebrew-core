class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v6.2.5.tar.gz"
  sha256 "d551fc7dfb7d9326a1ffdc44725499e880c03799b77e99026db95b24fcd82917"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f65ff1d0c1559dc24cd8c4db2d7728a1d4d6388cec1a007178094795271e6fbe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2da3bf541810b732f4da16193c4d962bbfe7ae4973ab272fa56a6f84e753088e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "341b8b3c1622308f8778f6b921db664b07a9be44d1cb809b0008f11e3473bc08"
    sha256 cellar: :any,                 arm64_linux:       "f6c19740305981eb14459c98df63bf5767ce3e7a2381d2ac1c7a8ccfb2514adc"
    sha256 cellar: :any,                 x86_64_linux:      "0d29f4bbc071a79545849caf1ecc41e38fb62fc63f03e296280d8daaed6e6f63"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
