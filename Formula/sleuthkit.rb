class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.5/sleuthkit-4.6.5.tar.gz"
  sha256 "674da80818ed667b2dcc70e58ca329b90bda791dc32d2eaabf2efcf6f07f05c4"

  bottle do
    cellar :any
    sha256 "ce1663cad76dedba6e23c936d5cf7e460242b7788b3d0c2398609aface6a0111" => :mojave
    sha256 "b2fbd5d22f83160c6f6625f8586ac22a53b479b4f728ca66e37128dcb4302c20" => :high_sierra
    sha256 "e10adcac8cd1e11875cbc44cf9a390a1a494820ba50183b6459c702b1f369a67" => :sierra
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
