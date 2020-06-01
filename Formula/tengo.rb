class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.5.0.tar.gz"
  sha256 "9e459e89d91a87eebd0398bdf22d1141d6c30359ddaf6308e3eb8bb2ce4aeaaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "e93b44babd50c01e3188d5a672644cfc58b571cf4c8c998cf9cd392c41c18546" => :catalina
    sha256 "e93b44babd50c01e3188d5a672644cfc58b571cf4c8c998cf9cd392c41c18546" => :mojave
    sha256 "e93b44babd50c01e3188d5a672644cfc58b571cf4c8c998cf9cd392c41c18546" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tengo"
  end

  test do
    (testpath/"main.tengo").write <<~EOS
      fmt := import("fmt")

      each := func(seq, fn) {
          for x in seq { fn(x) }
      }

      sum := func(init, seq) {
          each(seq, func(x) { init += x })
          return init
      }

      fmt.println(sum(0, [1, 2, 3]))   // "6"
      fmt.println(sum("", [1, 2, 3]))  // "123"
    EOS
    assert_equal shell_output("#{bin}/tengo #{testpath}/main.tengo"), "6\n123\n"
  end
end
