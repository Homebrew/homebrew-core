class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  url "http://www.radare.org/get/valabind-0.10.0.tar.gz"
  sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"
  revision 2

  head "https://github.com/radare/valabind.git"

  # Fixes incompatibility with BSD sed in valabind 0.10.0.
  patch do
    url "https://github.com/radare/valabind/pull/38.patch"
    sha256 "ed3573e43799e6635b951d68062c39947383afbf4f2bac2613a21e871b537100"
  end

  bottle do
    cellar :any
  end

  depends_on "gettext" => :linked
  depends_on "glib" => :linked
  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
