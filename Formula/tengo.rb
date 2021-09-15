class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.8.0.tar.gz"
  sha256 "445c7e240b1281359409f63804371424bba0b6ccb5e73465e9d9d5737261b2fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b6280d3ff67dcc14e298cb3907bf43ddac9929f5ad2fa379a66594fc9eb6f7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef70b95dc064e4f69cbff40bd5ddc35016e583dcce360c5c00b2dd34c866c9d0"
    sha256 cellar: :any_skip_relocation, catalina:      "ef70b95dc064e4f69cbff40bd5ddc35016e583dcce360c5c00b2dd34c866c9d0"
    sha256 cellar: :any_skip_relocation, mojave:        "ef70b95dc064e4f69cbff40bd5ddc35016e583dcce360c5c00b2dd34c866c9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "009006527b6ea9e9865650e12f19b3c86f71d5939d2212fcc472ff65b29ce27a"
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
