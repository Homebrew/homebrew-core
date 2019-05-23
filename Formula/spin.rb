class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://spinroot.com/spin/Src/spin649.tar.gz"
  version "6.4.9"
  sha256 "94eee2e854dc07b4e74f8e810ea3ff798678e8180db3c8df25d73a8fc7e4671d"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc68606f55b50ce72635956696ef717dd0451f91c64fcae20d6cd346f3220871" => :mojave
    sha256 "4748d5e21c7498ef2abfb5984980dee23ce7a3ff3130a6b13ffb9dffe1f75177" => :high_sierra
    sha256 "e1fd8d4855d41b00b2495adddb07933c6c460776b854f85dbe790e75aebb6fb6" => :sierra
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
