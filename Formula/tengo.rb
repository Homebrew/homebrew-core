class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.11.2.tar.gz"
  sha256 "bce3d6180eaaca682eaf814148a4b8278e8b0ad87bf322647e9817e29604508d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67b83d6f2cebdda0b7ade6d5790658c0ef044eb47b59ca8d2fb4f085e1b3eeba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67b83d6f2cebdda0b7ade6d5790658c0ef044eb47b59ca8d2fb4f085e1b3eeba"
    sha256 cellar: :any_skip_relocation, monterey:       "12d25c5ef97f07d7097d00f4e00d2d20e3569b371a11a1ed31d36ca2a842d6aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "12d25c5ef97f07d7097d00f4e00d2d20e3569b371a11a1ed31d36ca2a842d6aa"
    sha256 cellar: :any_skip_relocation, catalina:       "12d25c5ef97f07d7097d00f4e00d2d20e3569b371a11a1ed31d36ca2a842d6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdc490fd77b549902c5fc5bc895d6450f2167be13bd708122039604246d463d9"
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
