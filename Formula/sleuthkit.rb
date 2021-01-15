class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.10.1/sleuthkit-4.10.1.tar.gz"
  sha256 "65c3f701f046f012feba78452a50f1307948a1038474eaf8e296f65031604a0a"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/sleuthkit[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "c1ab47b1de34253319907d3ce1f9742109b225168ad5adec25d1abb62340543e" => :big_sur
    sha256 "6aff4ffcdfd49eb927b027f16b5ddb02bb7d74d24382ea3ed56fb0e14dee8af1" => :arm64_big_sur
    sha256 "32169b058d0500b740d6496bd5b9d1f87920d0d4a2c4b466f72d5857db88c449" => :catalina
    sha256 "96242dd0f595b9384e9d73e0c272c7105a98f13a66a010db796c538ec848bf24" => :mojave
    sha256 "076912d050385aca70b18f1a681c69cfcaa7237d87517b5d15457351701e7329" => :high_sierra
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
