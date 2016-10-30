class Skktools < Formula
  desc "SKK dictionary maintenance tools"
  homepage "http://openlab.jp/skk/index-j.html"
  url "http://openlab.ring.gr.jp/skk/tools/skktools-1.3.3.tar.gz"
  sha256 "0b4c17b6ca5c5147e08e89e66d506065bda06e7fdbeee038e85d7a7c4d10216d"

  bottle do
    cellar :any
    sha256 "0347744e8fb81108a0eb7a3bb99f6fd4debef7d34ac499e5312d458bde3b6134" => :sierra
    sha256 "1c7483904de37931199198fafd82bc3aee7ae3f9e89bf3c971aa13711579699f" => :el_capitan
    sha256 "eb770b46337d432b64c8dfd3e20d42212a32cdd00a8cffd92bb8e0ba32e46d6b" => :yosemite
    sha256 "541e53126d9e781515c1911d724e74c92bcefe790be8e7f187db04b35ba90a9d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-skkdic-expr2"

    system "make", "CC=#{ENV.cc}"
    ENV.j1
    system "make", "install"
  end
end
