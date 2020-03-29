class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://github.com/nimble-code/Spin/archive/version-6.5.2.tar.gz"
  sha256 "e46a3bd308c4cd213cc466a8aaecfd5cedc02241190f3cb9a1d1b87e5f37080a"

  bottle do
    cellar :any_skip_relocation
    sha256 "6432ab186b64f64851fa0f60dae53c13b6c9bfbc6195c41abc08f1ddfd824bf6" => :catalina
    sha256 "eae932021ba8a15f713dd60ca2a29267f5df53a832895c5ab1a342d2568c6f45" => :mojave
    sha256 "3ffbbe34633fa0e177bd25343b3bbd35d706988ab04c4a617fff530cf3dc542a" => :high_sierra
  end

  uses_from_macos "bison" => :build

  def install
    cd "Src" do
      system "make"
      bin.install "spin"
    end

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
