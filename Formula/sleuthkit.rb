class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.7/sleuthkit-4.6.7.tar.gz"
  sha256 "525fced79117929621fb583ed4a554a01a07e8739e9c000507acfa793f8d6915"

  bottle do
    cellar :any
    sha256 "bfbdb6c56045f3d156cff38715348d31689e85af228297460449c5cacac2240d" => :mojave
    sha256 "35582862b81d7885aa26b7888e41c462f943e3938b2a7752e072e47e91eac106" => :high_sierra
    sha256 "f9d09d2168a61bc4ecd679b694c8e0d6d0609786199aca994968bd2b8d3c2f7f" => :sierra
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on :java
  depends_on "libewf"
  depends_on "libpq"
  depends_on "sqlite"

  conflicts_with "irods", :because => "both install `ils`"
  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    cd "bindings/java" do
      system "ant"
    end
    prefix.install "bindings"
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
