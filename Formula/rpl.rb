class Rpl < Formula
  desc "Text replacement utility"
  homepage "http://www.laffeycomputer.com/rpl.html"
  url "https://web.archive.org/web/20170106105512/downloads.laffeycomputer.com/current_builds/rpl-1.4.1.tar.gz"
  sha256 "291055dc8763c855bab76142b5f7e9625392bcefa524b796bc4ddbcf941a1310"

  bottle do
    cellar :any_skip_relocation
    sha256 "79ed79d50ceaed30cc0fedaeeead5742208c72b04858863ceaf7951c7cbf8e00" => :mojave
    sha256 "70b23d5ce18f2dfe58e8c782a00e4ab56d88c1e43b135c9e9ba0c8c387bef470" => :high_sierra
    sha256 "2c9e55b51762d835db949c20f9eba36e83213082db82c69602658e2f28003b80" => :sierra
    sha256 "175e1f127c8c707b0d90c3c7e4399cc5c1e18410bf8b7f6ec9340dbca4c16e4b" => :el_capitan
    sha256 "d718355e56dd13c690f1d5a0541b5f051518f65b953aade9c525853a19266a61" => :yosemite
    sha256 "b0c4dbf06500053703ee4a8c8e751d43c435f0e3b0e25d2d328d310dcf490c23" => :mavericks
    sha256 "c59b98ff51670e96114daa8aa2c8984e35bd2bc1c2c01db9206bef9728a13624" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system "#{bin}/rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
