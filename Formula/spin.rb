class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://spinroot.com/spin/Src/spin647.tar.gz"
  version "6.4.7"
  sha256 "1b5743635cb77ad2ab94fb5bffad4b8ffa3270ffc610a23444da4af094eaa29e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6538cbbaaf03722bb07741815a68e7bfafdda3516f57bc2d2b352e2e89f1adb8" => :high_sierra
    sha256 "3922a022fe8111254653b476bba93245ee4cbfbb2695bd0327292eb08ba3cdd5" => :sierra
    sha256 "818364514a9d8e3cf3557ef7324bd881ceed0c70f956a4b2edd274ed9fb06f32" => :el_capitan
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
