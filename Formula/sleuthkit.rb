class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.4/sleuthkit-4.6.4.tar.gz"
  sha256 "90e5397bed861b08cfe8378f1a6032cfe50716056d2a47b0cac77e50a776ec41"

  bottle do
    cellar :any
    sha256 "51b30c280b302dd9d7ccc27778abf71d02a32d9b4095254737a8b278e45c8cd3" => :mojave
    sha256 "8ecc20e35a77e102b6ed5d45ad8dd707887d0bf47737323a5758205fd6d90ed4" => :high_sierra
    sha256 "ce8de5ba1d0be98895c2265a6927a93b1a99156e483517370c7ac42e2e457370" => :sierra
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
