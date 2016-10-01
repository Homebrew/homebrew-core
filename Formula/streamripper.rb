class Streamripper < Formula
  desc "Separate tracks via Shoutcasts title-streaming"
  homepage "http://streamripper.sourceforge.net/"
  url "https://downloads.sourceforge.net/sourceforge/streamripper/streamripper-1.64.6.tar.gz"
  sha256 "c1d75f2e9c7b38fd4695be66eff4533395248132f3cc61f375196403c4d8de42"

  bottle do
    cellar :any
    sha256 "3f055510dc825aa663f35c91aa5f4e5a57baacd69c00f0c428df4a98ad9b6a7e" => :sierra
    sha256 "eff1bb37cd652e9b3194e2fda3c682bda9da12f413a11c4e5e337c9bc849b2ea" => :el_capitan
    sha256 "3465e96b5f17000df88a85729674f911097ab9f1b0170a0c3c89f4892dba6fbb" => :yosemite
    sha256 "a92b924639b9210e83cae1e63baa8f9b45ab4ec38816e19e32ad6fbae420a510" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  fails_with :llvm do
    build 2335
    cause "Strange runtime errors with LLVM."
  end

  def install
    # the Makefile ignores CPPFLAGS from the environment, which
    # breaks the build when HOMEBREW_PREFIX is not /usr/local
    ENV.append_to_cflags ENV.cppflags

    chmod 0755, "./install-sh" # or "make install" fails

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
