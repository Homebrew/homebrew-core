class Spin < Formula
  desc "Efficient verification tool of multi-threaded software"
  homepage "https://spinroot.com/spin/whatispin.html"
  url "https://github.com/nimble-code/Spin/archive/version-6.5.2.tar.gz"
  sha256 "e46a3bd308c4cd213cc466a8aaecfd5cedc02241190f3cb9a1d1b87e5f37080a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67ce597f95a1d2ae0b428f11b95c962bdddace66cb2cc4127ad619ce5b9bea47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f8951592f6d019eafb6466a4e991c7437d13a699af047bbbbfd0bc4fdcb82bf"
    sha256 cellar: :any_skip_relocation, monterey:       "0d4b7b1254d58ccfb87f57dcedb3d86504c488bf7ca6ce8b44fd9d00523ec13c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d49e61e18c0c65108a64d3e0c91addbd011b3fff90434509958ebfe33b14c6cd"
    sha256 cellar: :any_skip_relocation, catalina:       "6432ab186b64f64851fa0f60dae53c13b6c9bfbc6195c41abc08f1ddfd824bf6"
    sha256 cellar: :any_skip_relocation, mojave:         "eae932021ba8a15f713dd60ca2a29267f5df53a832895c5ab1a342d2568c6f45"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3ffbbe34633fa0e177bd25343b3bbd35d706988ab04c4a617fff530cf3dc542a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6bc2cf070b8095de0b23f7ac8cd201c30c5e089c7635570b71ea7b9235753e1"
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
    assert_match "language is golang", output
  end
end
