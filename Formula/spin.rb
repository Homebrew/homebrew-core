class Spin < Formula
  desc "The efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://github.com/nimble-code/Spin/archive/version-6.5.1.tar.gz"
  sha256 "39a244763ee5dec8789f5461773249da82f05c53cc221636283366149284d14f"

  bottle do
    cellar :any_skip_relocation
    sha256 "aac939af6d78428b1a1bfcfddc2be77d93e566f1e6cce56b4ce5d102c22b6454" => :catalina
    sha256 "f189251ba154016bfc17dbc62f28499e29a62a9cc9ffc8339671bb7038f5754c" => :mojave
    sha256 "4069015b154f32290ae3e5ba29c1b520319e04c43977622ca836111c18d74bb1" => :high_sierra
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
