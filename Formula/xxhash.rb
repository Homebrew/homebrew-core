class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.6.1.tar.gz"
  sha256 "a940123baa6c71b75b6c02836bae2155cd2f74f7682e1a1d6f7b889f7bc9e7f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c0d900fab5dcbf8230bf8af1fb9f0002e8970fee209e80dd2d3229375e9fbda" => :el_capitan
    sha256 "9bc1fd241397723df5f4ad01046ca5fd6a2b14e4460e1a1a4c1a0b551f06d5ec" => :yosemite
    sha256 "ebe49542503582738be69f0a6c3558ab2ee7c60ce89dfa8e66f2da7e8c0bc054" => :mavericks
  end

  def install
    system "make"
    bin.install "xxhsum"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match /^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt")
  end
end
