class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "266b7baabe345e5d9bbd6652dc556925445f4ab5c80f2492f34ebc821b34e687"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a01034b3fe34bf8cd1bc9aed2895e5f12114fb82f0d3f77994a2d93caed8ed29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b55e841773b06e158ec02e843e19eb449c4df699c43596f63f6a36067ea24a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2df44be0ed4778fcf45dd009fafbfd10266a05719ba3d50a1e31fc2cff75849"
    sha256 cellar: :any_skip_relocation, sonoma:         "072471b9bfb9bca922727fad176a67dfb965804bd9e76e4c2b86f40610485480"
    sha256 cellar: :any_skip_relocation, ventura:        "ff7a7c4c4c20dda0db44a18f87105c447d3ac18ad37652f561d53ad9ae400617"
    sha256 cellar: :any_skip_relocation, monterey:       "ab141710c562b784101e2414d277a0492000f789c16463a0552438ab47aa50e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13a7060c6f50360d97b95c8371b0acf563ebd05c67d5b62c76737a14f049f7e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes,Files,ULOC
      C,4,4,0,0,0,50,1,0
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
