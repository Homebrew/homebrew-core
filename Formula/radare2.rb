class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/4.4.0.tar.gz"
  sha256 "401ab89f39f7e70e03336f6890dc4fdf52dae4f61201e4cd8a1fbe5a4b9eb451"
  license "LGPL-3.0"
  head "https://github.com/radare/radare2.git"

  bottle do
    sha256 "cbf47bb485878d4fda41e03e67493b0628ed1021ac97ea663736b3725f243f43" => :catalina
    sha256 "711e8178801c48a24b84a7ccae21491e07205735eb1e4bd693516a0bc13673eb" => :mojave
    sha256 "0893017e56d16e2e692a8928756b89e29df351852999d523f8a7f1c2f7e2e20d" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
