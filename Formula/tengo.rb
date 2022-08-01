class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.12.1.tar.gz"
  sha256 "4583ddf09e546e0ac8db81ade165efcff27c2b649873140b6d99ebee5931deb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5168c548d0bda18fe7a40870e2d3d89cbb2aaa59dd299238ff6f0a5c3427ab12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5168c548d0bda18fe7a40870e2d3d89cbb2aaa59dd299238ff6f0a5c3427ab12"
    sha256 cellar: :any_skip_relocation, monterey:       "bd30fb0d9ea9257d165bcd0c0fbcc73ec7d3a6011fefcec0805411df51368fad"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd30fb0d9ea9257d165bcd0c0fbcc73ec7d3a6011fefcec0805411df51368fad"
    sha256 cellar: :any_skip_relocation, catalina:       "bd30fb0d9ea9257d165bcd0c0fbcc73ec7d3a6011fefcec0805411df51368fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4051c09a64aa457647bc5274cfdef1ad04d14439fa7dc9edb0ffe380321582d"
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
