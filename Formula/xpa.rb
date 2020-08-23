class Xpa < Formula
  desc "Seamless communication between Unix programs"
  homepage "https://hea-www.harvard.edu/RD/xpa/"
  url "https://github.com/ericmandel/xpa/archive/2.1.20.tar.gz"
  sha256 "854af367c0f4ffe7a65cb4da854a624e20af3c529f88187b50b22b68f024786a"

  bottle do
    cellar :any_skip_relocation
    sha256 "754e739f0bc2964210fa4b794ed69f46374cd77b9b0dde8e7afba7196f724ada" => :catalina
    sha256 "660294618a8430fed54dad12001ee432ad057e7a9bd61615c356b3cd5359b1ac" => :mojave
    sha256 "29a855b77adcb642355fd4ffc78787507e75fac460f1f53994f7ba8f2324c1ac" => :high_sierra
  end

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # relocate man, since --mandir is ignored
    mv "#{prefix}/man", man
  end
end
