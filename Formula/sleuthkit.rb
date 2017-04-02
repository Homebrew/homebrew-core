class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-4.3.1.tar.gz"
  sha256 "91a9aa86041f8746038b8e8b0c6e07584971b025a9dd239c6f46d3db52c85d98"
  head "https://github.com/sleuthkit/sleuthkit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "a95620c4212372ae76222790745d772798729287f3af14ec84e419ec411b188e" => :sierra
    sha256 "c7f769eb76c40b27e501b96e41a95e8dc37dcaaca6464dbe60a1897a0e9d08fe" => :el_capitan
    sha256 "f8f5348d846630cfbe5041da4b225829c2cf9931677f0f4465dd9539326f4cef" => :yosemite
  end

  conflicts_with "irods", :because => "both install `ils`"

  option "with-jni", "Build Sleuthkit with JNI bindings"
  option "with-debug", "Build debug version"

  if build.with? "jni"
    depends_on :java
    depends_on :ant => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"
    ENV.java_cache if build.with? "jni"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          if build.without? "jni" then "--disable-java" end,
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with? "jni"
      cd "bindings/java" do
        system "ant"
      end
      prefix.install "bindings"
    end
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
