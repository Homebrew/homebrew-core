class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.11.1.tar.gz"
  sha256 "2e992bb4560d78d83bea97e95ddbe46f5a329df67e27b4620bcdfef7e3e539c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e594094ff8a94562666fc2efdfbc7bd531e2a717bc48769a28059511eab8ff30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e594094ff8a94562666fc2efdfbc7bd531e2a717bc48769a28059511eab8ff30"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1552f0168f84e1e8e31617ea7c9b628dbf7ac581fb3906aeabe00d3fc92fe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f1552f0168f84e1e8e31617ea7c9b628dbf7ac581fb3906aeabe00d3fc92fe2"
    sha256 cellar: :any_skip_relocation, catalina:       "0f1552f0168f84e1e8e31617ea7c9b628dbf7ac581fb3906aeabe00d3fc92fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d0f571c73f3b8baf939f779d497b62b85c7d6ee20a5d94f5ed52645524e4133"
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
