class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.6.2.tar.gz"
  sha256 "e4da793acbe411e7572124f958fa53b280e5f1821a8bf78d79ace972950b8f82"

  bottle do
    cellar :any_skip_relocation
    sha256 "795e650d2b1bc7c3dbb07df9de88943793f870ecafe5d5b1f4a4c298cb3b6a89" => :sierra
    sha256 "671fae000207ec694576432b608b3b994636c17083adea25ec2ef267bccdf064" => :el_capitan
    sha256 "59bff6aa6c09cd877ac3361b31e131e44aa7b50fee6c43539bc675797148a733" => :yosemite
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
