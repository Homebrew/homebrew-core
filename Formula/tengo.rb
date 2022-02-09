class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.10.1.tar.gz"
  sha256 "00c892a7cb4e847eefd36f5b8db695e184da5c090c6b509339c3b5d3a746232f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90101198df98dd22bf5c998f45ea61d180b68f9e53895d729c81a781816c6bfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90101198df98dd22bf5c998f45ea61d180b68f9e53895d729c81a781816c6bfb"
    sha256 cellar: :any_skip_relocation, monterey:       "cb178233c2cf0fa402be6efc77ff55dc8f3a3375b44673180e4fc6a3d365115c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb178233c2cf0fa402be6efc77ff55dc8f3a3375b44673180e4fc6a3d365115c"
    sha256 cellar: :any_skip_relocation, catalina:       "cb178233c2cf0fa402be6efc77ff55dc8f3a3375b44673180e4fc6a3d365115c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f1ff49848a49d5454bc006da15f2d08acf28f02c914de89f23e8cf8b00a61f"
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
