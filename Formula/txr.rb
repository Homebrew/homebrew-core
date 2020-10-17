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
    sha256 "a8f2d856fb79832c4c4ac464fde7a9e051a1f1f42c097b8b1669031f342b2743" => :catalina
    sha256 "6dbe9e6f5fd7a1e625b967d67c0b06a06f5212cb4cbb78673c3a4e001a7fef6a" => :mojave
    sha256 "e41a427ea900b7c0a700139f25ebb05576045d20afc04a45f656ec44ea5f0a05" => :high_sierra
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
