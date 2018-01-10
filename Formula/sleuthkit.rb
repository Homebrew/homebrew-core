class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.5.0/sleuthkit-4.5.0.tar.gz"
  sha256 "f74eb16e717598056a5664ae842d8acd276acfc340e8ebbd87d0948167e789ac"

  bottle do
    cellar :any
    sha256 "abbed8f1e02a2da3259481fac0a7583102f694e81afd757b4b7fc82102eb1e26" => :high_sierra
    sha256 "ea17c0cafff9eca82611837ce3d440dc7b66dd39a091dbd3b0286b95f84e2dda" => :sierra
    sha256 "0ae85140753e439df39bcfdf4abe0a25c779fadd5692dd214cb937b2f042adc6" => :el_capitan
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
