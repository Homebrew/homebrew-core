class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.6.1.tar.gz"
  sha256 "a940123baa6c71b75b6c02836bae2155cd2f74f7682e1a1d6f7b889f7bc9e7f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddce071034128693298eae6ca3ee5e0e755ea8045f79b8493b0d98b997bc8db8" => :sierra
    sha256 "221bdecb5b9a2b5833dd320ea789f05118db62d9308feec936f83348404228a1" => :el_capitan
    sha256 "0dea56c9e511eaacecf7688edd2ce0bb73a41eb196a7722f2985f8c084dc18fb" => :yosemite
    sha256 "30d8e9905d176797c6380bbde76954700b3ade6063c087fb9ce9dfbe8b3ccd12" => :mavericks
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
