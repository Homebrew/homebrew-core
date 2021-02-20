class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.6.2.tar.gz"
  sha256 "6ec3e8d668aa2451cab9adfa3c8712660eac2622bf60e1e45d5bdb198433eb79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d5f43136699df81970b5abb38b77f012698b30527037ee682977fdd2d64b7ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb5e85ed9514dee925ffa888f3227e51dce06a1729df74dc7bc9af2415a22dee"
    sha256 cellar: :any_skip_relocation, catalina:      "85740f093117930ce8a885a1fd9cad7e260c222d2e38be2d7299464806bffee8"
    sha256 cellar: :any_skip_relocation, mojave:        "843a89b74e67bc348c99419750292fd0e4ff2c77913badb99a4de784493c75b1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "035c213b4c8b252bfb81667a80b3bdef77bdb0dd7bed28fa7c557b1958f0e3e1"
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
