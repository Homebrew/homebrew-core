class Srm < Formula
  desc "command-line program to delete files securely"
  homepage "https://srm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/srm/1.2.15/srm-1.2.15.tar.gz"
  sha256 "7583c1120e911e292f22b4a1d949b32c23518038afd966d527dae87c61565283"

  bottle do
    cellar :any_skip_relocation
    sha256 "9143af437ad365572a4440c5e4cef405e2288f46978879383d93f2f47c206b0a" => :sierra
    sha256 "d035ef3e47fa1d69a7c05f4e0224e72bcb71b90664dae66c358dd769ba0bbaae" => :el_capitan
    sha256 "86c16f244e295dd1f3b81cabb162856250ad26f00778efc4e7afbb864334337d" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "srm_test"
    system bin/"srm", "srm_test"
    !File.exist? "srm_test"
  end
end
