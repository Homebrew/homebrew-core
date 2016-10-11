class TokyoDystopia < Formula
  desc "Lightweight full-text search system"
  homepage "http://fallabs.com/tokyodystopia/"
  url "http://fallabs.com/tokyodystopia/tokyodystopia-0.9.15.tar.gz"
  sha256 "28b43c592a127d1c9168eac98f680aa49d1137b4c14b8d078389bbad1a81830a"

  bottle do
    cellar :any
    sha256 "0a7da80cf5e8892112986d9a51e8cd3804da2a7436b8a03b472f561b06c35890" => :sierra
    sha256 "2a9e21b6f57781adb9e3dc673f2e466b817d4a00860b45fa49ded534d4cb0ed4" => :el_capitan
    sha256 "6fa4ed94aace1e4c3b2a9962f31055883325255f8175c63aa08f079a4974eb6e" => :yosemite
    sha256 "231960b2f9d41cc1ee48a66812b1f0fa5977613e39ddd1a62c22a46e21b3feaf" => :mavericks
    sha256 "a79ed3369dae255bff5344e0aa38039f65a8a25d9ef9f86c0068d49c3a4de009" => :mountain_lion
  end

  depends_on "tokyo-cabinet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.tsv").write <<-EOS.undent
      1\tUnited States
      55\tBrazil
      81\tJapan
    EOS

    system "#{bin}/dystmgr", "importtsv", "casket", "test.tsv"
    system "#{bin}/dystmgr", "put", "casket", "83", "China"
    system "#{bin}/dystmgr", "list", "-pv", "casket"
  end
end
