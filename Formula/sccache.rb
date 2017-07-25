class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.0.tar.gz"
  sha256 "441d9ffb4ae76cc8219ad4d372c1c3335dc81a144d795663e58161f25e1dc651"
  head "https://github.com/mozilla/sccache.git"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/sccache"
  end

  test do
    system "#{bin}/sccache", "--help"
  end
end
