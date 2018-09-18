class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.2/snapraid-11.2.tar.gz"
  sha256 "735cdeb7656ac48cbb0b4a89a203dd566505071e465d5effbcc56bcb8fd3a0d7"

  bottle do
    sha256 "f76d78e93603e753551db7f3460c36d8bcbfb17a70dbf213f50c1b037d8d1add" => :mojave
    sha256 "a3cdc8a3975bf5f3073e21d089d5e3c067fb809ccf758724f25fc092bebf7b71" => :high_sierra
    sha256 "eba431c9a6d92f379e0063c3c40cf6a655fa2a29256da707f851569046e7d7c9" => :sierra
    sha256 "e6be5ae4ae3aa3bffbd4f57c4dab84602d3883673ce9f2b74189a0f39c82b4b2" => :el_capitan
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
