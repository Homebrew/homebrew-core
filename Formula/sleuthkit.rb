class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.4.0/sleuthkit-4.4.0.tar.gz"
  sha256 "7d252562622f657001e080777c5fe1fd919b952fa3d658c86a62e57b6ad70f57"

  bottle do
    cellar :any
    sha256 "0b72a29c6fd822efd9a0185a9f5e144919b3e470e30fc7c8ce9313e7b7943e3f" => :sierra
    sha256 "d6c18c4e452c01c2cc451c4cbd7f2553ae338749448836913303bdf7cb1afff2" => :el_capitan
    sha256 "69843bf2119ca3851d07b79e5cde093eb9ac4ace1d3237a54e91c62212fdc680" => :yosemite
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
