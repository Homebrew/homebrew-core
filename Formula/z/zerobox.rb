class Zerobox < Formula
  desc "Sandbox any command with file, network, and credential controls"
  homepage "https://github.com/afshinm/zerobox"
  url "https://github.com/afshinm/zerobox/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "85a43ac5569437d4f0bd4b21dde82cc367812df2aa3d1f10175d8627c2c2f5f7"
  license "Apache-2.0"
  head "https://github.com/afshinm/zerobox.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libcap"
  end

  def install
    system "./scripts/sync.sh"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "crates/zerobox"
  end

  test do
    assert_match "zerobox", shell_output("#{bin}/zerobox --version")
  end
end
