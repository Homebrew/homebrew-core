class Wdfs < Formula
  desc "Webdav file system"
  homepage "http://noedler.de/projekte/wdfs/"
  url "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz"
  sha256 "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5"

  bottle do
    cellar :any
    sha256 "5c94bbb0f8a8139bcedce08d8cdc80cf796c3d801103f1688b415c570be3c298" => :mojave
    sha256 "204b9c0227c3ccf14444259fea4e26cedc42eb2e461ce02952bf4d7f2802fb66" => :high_sierra
    sha256 "d88bd5f277e42a04048c6641e764c919b71b4cec554440ddb590b608c7d02955" => :sierra
    sha256 "7133df159d9ca995fd982a7ffc2e3213112113e740c6ed5a5c48458d1f1bd1c3" => :el_capitan
    sha256 "f427e5e1cde130dc890db1f27e7bbc8600ae9a22dfbb3fcdc8ada9eb73686f51" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "neon"
  depends_on :osxfuse

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wdfs", "-v"
  end
end
