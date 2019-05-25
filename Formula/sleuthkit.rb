class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.6/sleuthkit-4.6.6.tar.gz"
  sha256 "cfc9cd1e777ec2d13f0422cba4583d0279315e406e2e37cbb153b3d07faf11c6"

  bottle do
    cellar :any
    sha256 "01a7a2766ade79e43d163c03f2c580cdc463221d90f000178ea6a82cdee92134" => :mojave
    sha256 "66d9be8a0042223bea0db051e5a9412a485e8ef800411d160caba7eb57d073f0" => :high_sierra
    sha256 "4cfb4188da9952d9f25c8aaed5170b82904e8eb4f4bec748adb4b64502b05ac8" => :sierra
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
