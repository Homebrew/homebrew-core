class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "61279c893e0c0d2a02a21c9e724a0124e719798948776e1bac41b7fb845136ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c93892d0177b5d0520a654866c4822554a5a06a8599afdee5185166238e2443d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10c3e44f039ecd6b7f43ceabf80249654e25a079270b25373066051a08e0bdcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c3e44f039ecd6b7f43ceabf80249654e25a079270b25373066051a08e0bdcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10c3e44f039ecd6b7f43ceabf80249654e25a079270b25373066051a08e0bdcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "250e938de1c268bbaa0dcb010df63c3d6427476c2a317e5ee40e4f67dd2d2b85"
    sha256 cellar: :any_skip_relocation, ventura:       "250e938de1c268bbaa0dcb010df63c3d6427476c2a317e5ee40e4f67dd2d2b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98750059e6eab32be3c593d770fd330c7b5c9be19305cb795151ea4ec0597faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4c55cd3c296195d74538e9f8c922f6f3b1e12414733ffac200589d584193858"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tengo"
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
    assert_equal "6\n123\n", shell_output("#{bin}/tengo #{testpath}/main.tengo")
  end
end
