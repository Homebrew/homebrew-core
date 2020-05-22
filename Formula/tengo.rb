class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.3.2.tar.gz"
  sha256 "dd980bd3199bf0811800afe4e4874fdbe3385b1d1351111ebf758195fca2c5e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "848a63d9adc3e74bf9e113f3e774c9155a1565d7aea43fb0d760c0f319f1dfe8" => :catalina
    sha256 "848a63d9adc3e74bf9e113f3e774c9155a1565d7aea43fb0d760c0f319f1dfe8" => :mojave
    sha256 "848a63d9adc3e74bf9e113f3e774c9155a1565d7aea43fb0d760c0f319f1dfe8" => :high_sierra
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
