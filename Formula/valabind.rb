class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://radare.org/"
  url "https://github.com/radare/valabind/archive/1.7.1.tar.gz"
  sha256 "b463b18419de656e218855a2f30a71051f03a9c4540254b4ceaea475fb79102e"
  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "c149f20a01849a3ee477d0ea236fd78fedd45d2c1fe8ebc97bdf637f2fa4cec5" => :mojave
    sha256 "9cc2312ef64b8f1d39a36d9b157d9112920ebdda221e64d0680b32e641e0a795" => :high_sierra
    sha256 "e9ffa47579200c0f8a1394c6495b1c8c52d581084bcd9273121d4e907fff307c" => :sierra
    sha256 "c43502d503c09c23f2c225250c5e8ccf9f7100b88703767f27ceed729b55a8c3" => :el_capitan
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
