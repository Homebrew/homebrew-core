class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.12.1/sleuthkit-4.12.1.tar.gz"
  sha256 "6b2de0baabc6a38429a33993114ca3820329b477d5038cbf45fcf69fca8addfd"
  license all_of: ["IPL-1.0", "CPL-1.0", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    regex(/sleuthkit[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bc97ef36de9b6624b24bc4714892ed4463cbe5a53d1885c2ca73cb846ae97d15"
    sha256 cellar: :any,                 arm64_sonoma:   "3990023db44a7191cbfc5318b11cf1c9a9765792551aca8e4745928844356c03"
    sha256 cellar: :any,                 arm64_ventura:  "b0d6b888b6dc5d2b56529e5248819ce846247d4d3d032bb5ac1d8dc1e9f9e000"
    sha256 cellar: :any,                 arm64_monterey: "024475cedc9b7c93d859d7f0d9d1f3caf1a230c0031057ccdf25358dd52f547d"
    sha256 cellar: :any,                 arm64_big_sur:  "698de2bfd8547d0e7fa0af37ed53769b62cf3cfe76bf99d973fde959f1ee6c32"
    sha256 cellar: :any,                 sonoma:         "91013e0cce89b5b13af7fc87d41e0401d3a0c25d8f824a5c96562d9a7943c5bb"
    sha256 cellar: :any,                 ventura:        "eb57d772689a6ee1926862943c15c9e750d22533a09ed06f212dc3bb99e5edb0"
    sha256 cellar: :any,                 monterey:       "d5531da323b8ca2b37477e4623f5381ce2356351a2db8ff4c638dcffba6de7f7"
    sha256 cellar: :any,                 big_sur:        "f240f357fb63d8ccfa74881cd780a87634ea2fc4dfb2e90b7ad315a5ec95007a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e24e6cb55111d166861658d14bfb81dcdfce1850550a7c83e9303b3ee63a59"
  end

  depends_on "ant" => :build

  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"
  depends_on "sqlite"

  uses_from_macos "zlib"

  conflicts_with "ffind", because: "both install a `ffind` executable"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV["ANT_FOUND"] = Formula["ant"].opt_bin/"ant"
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    cd "bindings/java" do
      system "ant"

      inreplace ["Makefile", "jni/Makefile"], Superenv.shims_path/"ld", "ld" if OS.linux?
    end
    prefix.install "bindings"
  end

  test do
    system bin/"tsk_loaddb", "-V"
  end
end
