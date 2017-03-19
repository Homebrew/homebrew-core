class Srm < Formula
  desc "command-line program to delete files securely"
  homepage "https://srm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/srm/1.2.15/srm-1.2.15.tar.gz"
  sha256 "7583c1120e911e292f22b4a1d949b32c23518038afd966d527dae87c61565283"

  bottle do
    cellar :any_skip_relocation
    sha256 "3965dac338dab92d3c25306ec55dda0b1b75b78fb1f9060cd2e1c7b1e842f7a5" => :el_capitan
    sha256 "bad23b6a0f2eebf37cc5b9f02f0001f5bf5af46fab55dd67aeb7b67796891b90" => :yosemite
    sha256 "800ceccc9adecec1ceabfbc6c3d2aaa1da682db174ab02ae75cbcbba4cee1270" => :mavericks
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
