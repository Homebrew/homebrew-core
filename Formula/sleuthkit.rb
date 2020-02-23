class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.8.0/sleuthkit-4.8.0.tar.gz"
  sha256 "f584b46c882693bcbd819fb58f75e9be45ac8abdbf605c190f87ef1122f28f6c"

  bottle do
    cellar :any
    sha256 "7cbf955a3df686e370616256ce35b7f4c6734c32b4446a3c7af3fdb6ec843569" => :catalina
    sha256 "edd55849d72f35c2f7210d0760b5f21e6204e900a4da977a8c19fa6db3d5cf7b" => :mojave
    sha256 "1938217697347d823ca2d915c9ab2046843d675b9d07dea38c1c452637a6db1e" => :high_sierra
    sha256 "c8ce9b0639eb21ea41344bc117df1dda8ac103400be32dd412f79b6d18ebb50f" => :sierra
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
