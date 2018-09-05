class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.2/sleuthkit-4.6.2.tar.gz"
  sha256 "12369a753739fa6079177d8a034da4d0e4c7075c59031af53960059757042ace"

  bottle do
    cellar :any
    sha256 "5a3496c80ccb0e06f322e1b469cf0adf28f6f7f10ec7921a6b2509832aa27460" => :mojave
    sha256 "ee6b4ae1e8cb351311e9ef810b1b92d847751e4e17a722eef12fbb700a69718e" => :high_sierra
    sha256 "1b7336477311e5dfb97d6fdaa18732441d79c74098edbdc33cd9ac13c6159263" => :sierra
    sha256 "879fcb4c26d6245a80fb135cfb325526046ea22e4e82bc178cd51616d7987b90" => :el_capitan
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
