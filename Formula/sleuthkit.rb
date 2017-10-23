class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.5.0/sleuthkit-4.5.0.tar.gz"
  sha256 "f74eb16e717598056a5664ae842d8acd276acfc340e8ebbd87d0948167e789ac"

  bottle do
    cellar :any
    sha256 "7ea055e4657be61ef7e37fd9103c8d7d12feb241d2eda0b1a75fa804a3a321cc" => :high_sierra
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
