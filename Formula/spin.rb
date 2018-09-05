class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://spinroot.com/spin/Src/spin648.tar.gz"
  version "6.4.8"
  sha256 "0035bb114157a759e047c7f94ede0a3d7149003893914c9bbdff45e074ab6ae7"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e4e65759c869d3b4964139b731725f4b6aba48ee722f5ed8824f92a8b097b77" => :mojave
    sha256 "11dcb2192a287c7bdbdbf7109add8ffb9c33161b12b4342c9feef21fd16269d1" => :high_sierra
    sha256 "5d881e899d308eee2c72c19050d61f70c53b439d7cb5b188dd6e104345a6fa35" => :sierra
    sha256 "f64e72a5667316b47f32d7c1af206a7735708bbbb1a02e7d6d752d1e7e63b3ad" => :el_capitan
  end

  def install
    ENV.deparallelize

    cd "Src#{version}" do
      system "make"
      bin.install "spin"
    end

    bin.install "iSpin/ispin.tcl" => "ispin"
    man1.install "Man/spin.1"
  end

  test do
    (testpath/"test.pml").write <<~EOS
      mtype = { ruby, python };
      mtype = { golang, rust };
      mtype language = ruby;

      active proctype P() {
        do
        :: if
          :: language == ruby -> language = golang
          :: language == python -> language = rust
          fi;
          printf("language is %e", language)
        od
      }
    EOS
    output = shell_output("#{bin}/spin #{testpath}/test.pml")
    assert_match /language is golang/, output
  end
end
