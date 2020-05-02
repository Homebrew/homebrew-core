class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.9.0/sleuthkit-4.9.0.tar.gz"
  sha256 "7bc5ee9130b1ed8d645e446e0f63bd34ad018a93c1275688fa38cfda28bde9d0"

  bottle do
    cellar :any
    sha256 "a295524b0f1cacd5e67084eec862dae99f1c2787035f2322189982840b37fd73" => :catalina
    sha256 "02ad0263a10f422f630205b332a5361921f4d33d943fe099afeee98feb5ef1bd" => :mojave
    sha256 "97657fb6014fa5bde41bbdc79a31ba911a782531cc3b9ac1f01125fe1951d751" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"

  uses_from_macos "sqlite"

  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    ENV["ANT_FOUND"]=Formula["ant"].opt_bin/"ant"
    ENV["SED"]="/usr/bin/sed"
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
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
