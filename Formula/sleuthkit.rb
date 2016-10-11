class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "http://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/archive/sleuthkit-4.3.0.tar.gz"
  sha256 "64a57a44955e91300e1ae69b34e8702afda0fb5bd72e2116429875c9f5f28980"
  head "https://github.com/sleuthkit/sleuthkit.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e33b1f36f3ab7991d5e2c068b432c5d3561c8cbe1fa322e1c0ff2d3d24863267" => :sierra
    sha256 "94a181b0a105afdf4540c13427df2a082d80130ceed8f5b2e3bc840d4d9d282f" => :el_capitan
    sha256 "f5b10d0269c943ea948386d2fe82ab7b5e8bf10d961889f1c5960c5eff0f08cc" => :yosemite
    sha256 "c6045be0a652903ab303584e521aaae53a7fdb82af2b008408017749a22beacb" => :mavericks
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
