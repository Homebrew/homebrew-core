class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.6.0/sleuthkit-4.6.0.tar.gz"
  sha256 "f52a08ab0de078182c0f2d19d3e1b341424a9e0c1633a61c3b892fb38f9acb97"

  bottle do
    cellar :any
    sha256 "d418bac269354588ffd2d16ed9f52bdde27a712333c34dab26ef816c210196c6" => :high_sierra
    sha256 "cf98bd7df825bb78b3f7066da21fd65f55fe273023e16d08f448bc5c3f69c1c5" => :sierra
    sha256 "dd9aaa5cba9a55db4132a31c308fc111e8bd1b66f7fa1255e045ffa110a7a6ba" => :el_capitan
  end

  option "with-jni", "Build Sleuthkit with JNI bindings"
  option "with-debug", "Build debug version"

  depends_on "afflib" => :optional
  depends_on "libewf" => :optional

  if build.with? "jni"
    depends_on :java
    depends_on "ant" => :build
  end

  conflicts_with "irods", :because => "both install `ils`"
  conflicts_with "ffind",
    :because => "both install a 'ffind' executable."

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"

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
