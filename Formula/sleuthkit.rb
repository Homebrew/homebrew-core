class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.2/sleuthkit-4.6.2.tar.gz"
  sha256 "12369a753739fa6079177d8a034da4d0e4c7075c59031af53960059757042ace"

  bottle do
    cellar :any
    sha256 "191e42868facb70b4a2d73e9d23d4283aee9248c2aae5865dc3eb5209f402cf4" => :high_sierra
    sha256 "dc59fb5ee7eb2467fa01e1743fb4ba25660a898f7cb7a202aeab8ec90abd84c9" => :sierra
    sha256 "994034b47b0992fa5c651787de90a548edf5a2ccddee7eb4e7a96bd74b23b470" => :el_capitan
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
