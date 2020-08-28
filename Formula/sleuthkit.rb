class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.9.0/sleuthkit-4.9.0.tar.gz"
  sha256 "7bc5ee9130b1ed8d645e446e0f63bd34ad018a93c1275688fa38cfda28bde9d0"
  license "GPL-2.0"

  livecheck do
    url "https://github.com/sleuthkit/sleuthkit/releases/latest"
    regex(%r{href=.*?/tag/sleuthkit[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "e3bb514d3df5d19a066b27a455f04066dbaefbf0bfd80f3a10d5cbf73f7549f5" => :catalina
    sha256 "9f912c67f95edfa547d9fcc03d63920d3b47964aeb5e8f548d2df5e2635ef0ed" => :mojave
    sha256 "1234854d9ae4a77d083d94d9a1d0f21891d479bf80a87191f6df68076506de2d" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"

  uses_from_macos "sqlite"

  conflicts_with "ffind",
    because: "both install a `ffind` executable"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    ENV["ANT_FOUND"]=Formula["ant"].opt_bin/"ant"
    ENV["SED"]="/usr/bin/sed"
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    cd "bindings/java" do
      system "ant"
    end
    prefix.install "bindings"
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
