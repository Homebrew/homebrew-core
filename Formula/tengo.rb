class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.14.0.tar.gz"
  sha256 "00c9dfaabcdf8c0f5138de30490e2aad4e6c1955467f900657200e54eb09d9e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d85d1ce54775da75d382ecc65e9b0048e2e015b6de694b6a4ac0b2420c41922d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d85d1ce54775da75d382ecc65e9b0048e2e015b6de694b6a4ac0b2420c41922d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d85d1ce54775da75d382ecc65e9b0048e2e015b6de694b6a4ac0b2420c41922d"
    sha256 cellar: :any_skip_relocation, ventura:        "83d2b450f38db09e4510790fc0982983bbeb2a7a40e1f2d455cc83a222592d71"
    sha256 cellar: :any_skip_relocation, monterey:       "83d2b450f38db09e4510790fc0982983bbeb2a7a40e1f2d455cc83a222592d71"
    sha256 cellar: :any_skip_relocation, big_sur:        "83d2b450f38db09e4510790fc0982983bbeb2a7a40e1f2d455cc83a222592d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e336ad40544a805f45f3a24175d97d11d88f957d12ca79c2b2f6a2c2ee73cf5f"
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
