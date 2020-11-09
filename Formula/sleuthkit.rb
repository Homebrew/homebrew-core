class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.10.1/sleuthkit-4.10.1.tar.gz"
  sha256 "65c3f701f046f012feba78452a50f1307948a1038474eaf8e296f65031604a0a"
  license "GPL-2.0"

  livecheck do
    url "https://github.com/sleuthkit/sleuthkit/releases/latest"
    regex(%r{href=.*?/tag/sleuthkit[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "e47a99c263a1b06224fccb9eaec9caedd1311bc096880fac9960787d8d5a1635" => :catalina
    sha256 "76edae424b8f1d0072cf26ef88c56cf72dc2d441c2fc251aebd7bc4e6aa52bde" => :mojave
    sha256 "70cd25ef00d43c30a8812858dfd8ab7aa47e93589a5b99f5450c289464f58079" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"

  uses_from_macos "sqlite"

  conflicts_with "ffind",
    because: "both install a `ffind` executable"

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
