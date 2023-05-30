class Sonixflasher < Formula
  desc "CLI-based Flasher for Sonix 24x/26x MCUs"
  homepage "https://github.com/SonixQMK/SonixFlasherC"
  # Use the tag instead of the tarball to get submodules
  url "https://github.com/SonixQMK/SonixFlasherC.git",
     tag: "1.0.0", revision: "41ae51cef5021a340016d95372e08f2f6c94863a"
  license "GPL-3.0-only"

  def install
    system "make", "sonixflasher"
    bin.install "sonixflasher"
  end

  test do
    output = shell_output("#{bin}/sonixflasher -f test.bin 2>&1", 139)
    assert_match "ERROR: Could not open file (Does the file exist?).\n", output
  end
end
