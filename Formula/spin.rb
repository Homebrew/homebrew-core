class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://github.com/nimble-code/Spin/archive/version-6.5.0.tar.gz"
  sha256 "7bd764793621940b7e69eef8210c82c75ccee7745f24927f221d228260505333"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa2c31e9fcd14764f4cd217256ea30caba446a3dadd295adb2dfba4baadc42c4" => :catalina
    sha256 "92ea7a4b20e4d8409df68c717caddc537c0cfb578040f4eb6b48846e64aeef08" => :mojave
    sha256 "ab5249a0e58f7ee677defc10bd187c6ef5ee3ddc5eb5cf0ba4747b222ccb7ed8" => :high_sierra
    sha256 "82e328f8c23068ad8dc2f722cf6872e0dfab0e68eb1b10813f1aaa6d0c667caf" => :sierra
  end

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
