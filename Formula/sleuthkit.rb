class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.4.0/sleuthkit-4.4.0.tar.gz"
  sha256 "7d252562622f657001e080777c5fe1fd919b952fa3d658c86a62e57b6ad70f57"

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

  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"
    ENV.java_cache if build.with? "jni"

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
