class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://github.com/radare/valabind/archive/1.6.0.tar.gz"
  sha256 "0d266486655c257fd993758c3e4cc8e32f0ec6f45d0c0e15bb6e6be986e4b78e"
  head "https://github.com/radare/valabind.git"

  bottle do
    sha256 "09ecd58afe5c101c661d20c18a229ca4d8204adfd65d508e6e46387faf8a5980" => :high_sierra
    sha256 "05e13594c23aca12a1ea9c7ff4a5e3a17bbe1a68a65dea80d5a8aa89892d26cf" => :sierra
    sha256 "bf466be7a14313608f3d68a86135b2b25094457c0fb89b7dd389f57fc4cd173c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
