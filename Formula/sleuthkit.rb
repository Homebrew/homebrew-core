class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.4.2/sleuthkit-4.4.2.tar.gz"
  sha256 "135964463f4b0a58fcd95fdf731881fcd6f2f227eeb8ffac004880c8e4d8dd53"

  bottle do
    cellar :any
    sha256 "58e1527d98ad4284fb5a4f78e315d4c8626a618c5f47035761ca3b0e147b152d" => :sierra
    sha256 "6afe4510ae6e1c707f3f5e3e7ad40e9c539bfea3f5ac45f25949a8c4ab5a536d" => :el_capitan
    sha256 "eda246e21dbf2974eb352c0ff57c313a4d8778526c16cc977c4fa807d4cbf12a" => :yosemite
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
