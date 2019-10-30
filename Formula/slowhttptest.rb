class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.8.tar.gz"
  sha256 "31f7f1779c3d8e6f095ab19559ea515b5397b5c021573ade9cdba2ee31aaef11"
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    sha256 "87ffd6f13e4643eba8434b08287bbb370fea6a6f38383c579c92cb11a3b8e689" => :catalina
    sha256 "b9cc1a26d74eed668f3f337e0bd5a639e7017c5b9b50ec90c68290f56efe946d" => :mojave
    sha256 "e99ac598ee7bce8c956cac5db78bbde906266debee14f9586e72f933e8a471a0" => :high_sierra
    sha256 "8c1228a2dfd57a36124947ddde4981493c52ca5f94b48649afacc7c94b9f32bb" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"
  end
end
