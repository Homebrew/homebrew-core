class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://spinroot.com/spin/Src/spin647.tar.gz"
  version "6.4.7"
  sha256 "1b5743635cb77ad2ab94fb5bffad4b8ffa3270ffc610a23444da4af094eaa29e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ffa6cc425fa0a3e76b2f985a5d04c247b0c2d42bd79d27142e4b00fdb10bcf9" => :high_sierra
    sha256 "f84993497ff79a79f02e629b692a429a9576d013522123b44e9daeed4310d9f9" => :sierra
    sha256 "675449c646388047b03b50d7fa825654fa056e857d50e8729875765990acb240" => :el_capitan
    sha256 "6d88fb1d345bcb7f49cb8624e02b4c1895d09f383c502fb62a6631df8037b836" => :yosemite
    sha256 "974442a06ab42b2ba3dd16818a1bd201cc064fa6995e133b196d643b03d4eda7" => :mavericks
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
