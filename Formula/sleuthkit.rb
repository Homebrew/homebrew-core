class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.4.1/sleuthkit-4.4.1.tar.gz"
  sha256 "d90eed4064be64f156fa36a17c724bea9e76d3f4993eb092e977fb394b90130c"

  bottle do
    cellar :any
    sha256 "0b72a29c6fd822efd9a0185a9f5e144919b3e470e30fc7c8ce9313e7b7943e3f" => :sierra
    sha256 "d6c18c4e452c01c2cc451c4cbd7f2553ae338749448836913303bdf7cb1afff2" => :el_capitan
    sha256 "69843bf2119ca3851d07b79e5cde093eb9ac4ace1d3237a54e91c62212fdc680" => :yosemite
  end

  option "with-jni", "Build Sleuthkit with JNI bindings"
  option "with-debug", "Build debug version"

  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  if build.with? "jni"
    depends_on :java
    depends_on :ant => :build
  end

  conflicts_with "irods", :because => "both install `ils`"
  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"
    ENV.java_cache if build.with? "jni"

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--disable-java" if build.without? "jni"

    system "./configure", *args
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
