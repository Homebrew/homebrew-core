class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.6.0.tar.gz"
  sha256 "3a1c4c53b9791da67b261929fd742d24cbd678832fdc896de382f0c4e97bc5c2"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2c5d13206abe7acff924d0b1d4a93b8c34ed4487e5e26d203579aa4326227b0" => :catalina
    sha256 "c2c5d13206abe7acff924d0b1d4a93b8c34ed4487e5e26d203579aa4326227b0" => :mojave
    sha256 "c2c5d13206abe7acff924d0b1d4a93b8c34ed4487e5e26d203579aa4326227b0" => :high_sierra
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
