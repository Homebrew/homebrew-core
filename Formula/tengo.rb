class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.1.2.tar.gz"
  sha256 "6940faef1e77cda77d791295a49d1034f23023445a63cff8391622acfb10a09a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3cd1bd6316ad686042587f752726a5a45cc81e4de633c92b7dcb3371726623f" => :catalina
    sha256 "f3cd1bd6316ad686042587f752726a5a45cc81e4de633c92b7dcb3371726623f" => :mojave
    sha256 "f3cd1bd6316ad686042587f752726a5a45cc81e4de633c92b7dcb3371726623f" => :high_sierra
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
