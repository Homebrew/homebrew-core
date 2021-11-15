class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "https://github.com/radare/valabind"
  url "https://github.com/radare/valabind/archive/1.8.0.tar.gz"
  sha256 "3eba8c36c923eda932a95b8d0c16b7b30e8cdda442252431990436519cf87cdd"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/radare/valabind.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e3ab92ce9929d10db47821cb54a99943397f7708bcf9bac7fba29e5c1a5a184d"
    sha256 cellar: :any,                 big_sur:       "bef04beaf352699df3774e1d26423b16cdd487836553755d6777b5d3a20e4413"
    sha256 cellar: :any,                 catalina:      "d1013e81b20cf4c4981b7840c12d281fb2042aebb874317e8dff44d550915954"
    sha256 cellar: :any,                 mojave:        "ca8cb97fd10e22e1ac1a8966889c9eda14f33bedeeae8395811c55748e2740cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60a5907d80687fc3bf619f357d525ed856aaedf23dbad26fcd8c80636b37698"
  end

  depends_on "pkg-config" => :build
  depends_on "swig"
  depends_on "vala"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "make", "VALA_PKGLIBDIR=#{Formula["vala"].opt_lib}/vala-#{Formula["vala"].version.major_minor}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
