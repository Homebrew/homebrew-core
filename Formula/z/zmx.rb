class Zmx < Formula
  desc "Session persistence for terminal processes"
  homepage "https://github.com/neurosnap/zmx"
  url "https://github.com/neurosnap/zmx/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "96b7d548773dba64500da46f4d5550f7ef5d81130849d882d86191a319d8cd02"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match "session persistence", shell_output("#{bin}/zmx help")
  end
end
