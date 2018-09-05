class Xpa < Formula
  desc "Seamless communication between Unix programs"
  homepage "https://hea-www.harvard.edu/RD/xpa/"
  url "https://github.com/ericmandel/xpa/archive/v2.1.18.tar.gz"
  sha256 "a8c9055b913204babce2de4fa037bc3a5849941dcb888f57368fd04af0aa787b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c73a6afbb9764d9b7d6b5199b45bc5ed39edf5778c81f01a17b7dcd6e6c2e621" => :mojave
    sha256 "c9163ee736fde3dd56d4420121fc61a710bf88feab805e5b2c9cc31630a3be1f" => :high_sierra
    sha256 "6aa70ab2200ded59d1bbd466b915311c52313bf07f2c398362ce8f5bbb29c597" => :sierra
    sha256 "f8b188638f71cecd974279f07d55b932be7c657f83c7e55634c011df7cb44a63" => :el_capitan
    sha256 "2c79a17701b6c38017eb1e02954302912d6618fc7666b46bd7f1d7019632c318" => :yosemite
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
