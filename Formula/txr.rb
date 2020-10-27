class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-244.tar.bz2"
  sha256 "192cebb4edf89fcf0010cf3982a058ee5019abf28336bcf47cd3a5c1bb392b58"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0ad6e1b88ac7dc2f29b99e1944c16a36479529af9e8154b94fd097c71bb12e18" => :catalina
    sha256 "ce5b9bd68469716f93df3a30f5f0cc5348054ccc4206c181186afa3ffb812882" => :mojave
    sha256 "4def7304997039f48be24742fa670c5e8f292dd3256793696b09bf9da31cafd7" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
