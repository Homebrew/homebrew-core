class Relift < Formula
  desc "Free, open-source data recovery for Windows, macOS, and Linux"
  homepage "https://github.com/ShahabAhmed01/relift"
  url "https://github.com/ShahabAhmed01/relift/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "27966eef7bd14123999f24af743cd0e62d89f1dfcf43878e72532e943dc2277c"
  license "GPL-3.0-or-later"
  head "https://github.com/ShahabAhmed01/relift.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/relift-cli")
  end

  test do
    assert_match "relift 0.1.0", shell_output("#{bin}/relift --version")
    assert_match "devices", shell_output("#{bin}/relift --help")
  end
end
