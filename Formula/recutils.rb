class Recutils < Formula
  desc "Tools to work with human-editable, plain text data files"
  homepage "https://www.gnu.org/software/recutils/"
  url "https://ftp.gnu.org/gnu/recutils/recutils-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/recutils/recutils-1.7.tar.gz"
  sha256 "233dc6dedb1916b887de293454da7e36a74bed9ebea364f7e97e74920051bc31"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "c0663d82d44c2fb4c4baf0228e4f2e093ea15fd263447714ab2d9890a827ce1e" => :high_sierra
    sha256 "a984710e11a1c350b9f59c37a7e1548bb0ddf500fad66d727085d1f7190227d8" => :sierra
    sha256 "b05bab96785a80e5bef03d810ab0f764db53856e1fba5fa65d2b4db25fe3575c" => :el_capitan
    sha256 "b91cd49a977ff93d079ac65a637b6d9681f045368e06a0a1d630ca97e14bd11a" => :yosemite
    sha256 "7e323f2500199e0b1d8fbbd26b33c022c56a9582abdefa401c4629d7152b7f4d" => :mavericks
    sha256 "aec2464c5e26a561b340e9ae5a080366a068936ff2ba4e86e6a4bcf0ed8a95d0" => :mountain_lion
  end

  if MacOS.version >= :high_sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    system "#{bin}/csv2rec", "test.csv"

    (testpath/"test.rec").write <<~EOS
      %rec: Book
      %mandatory: Title

      Title: GNU Emacs Manual
    EOS
    system "#{bin}/recsel", "test.rec"
  end
end
