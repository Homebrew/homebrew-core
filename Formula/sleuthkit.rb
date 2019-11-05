class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.7.0/sleuthkit-4.7.0.tar.gz"
  sha256 "24b95ab1d65cc3248c6f735eae033d7090c5bb65bae12d2c1d3cffa1422fdc35"

  bottle do
    cellar :any
    sha256 "7cbf955a3df686e370616256ce35b7f4c6734c32b4446a3c7af3fdb6ec843569" => :catalina
    sha256 "edd55849d72f35c2f7210d0760b5f21e6204e900a4da977a8c19fa6db3d5cf7b" => :mojave
    sha256 "1938217697347d823ca2d915c9ab2046843d675b9d07dea38c1c452637a6db1e" => :high_sierra
    sha256 "c8ce9b0639eb21ea41344bc117df1dda8ac103400be32dd412f79b6d18ebb50f" => :sierra
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on :java => "1.8"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "sqlite"

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
