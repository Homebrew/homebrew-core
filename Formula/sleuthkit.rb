class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.4.2/sleuthkit-4.4.2.tar.gz"
  sha256 "135964463f4b0a58fcd95fdf731881fcd6f2f227eeb8ffac004880c8e4d8dd53"

  bottle do
    cellar :any
    sha256 "d478c2900f29bbad2d04a4c1ab8e24028679ce84b2d2267fb9fcfb08888785ca" => :sierra
    sha256 "ed54e5ddcaf563928f0c483ef615f7cc18100c1ae1ff2824cd9423476b16bd26" => :el_capitan
    sha256 "f4edf6e196e9c1fb3ef90b97cd7c3560ef893fa79325e524e6f6e5f46d25c67f" => :yosemite
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
