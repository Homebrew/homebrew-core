class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.10.0.tar.gz"
  sha256 "487331f79a3742fc05817d6210f6fb751b3ade90826910dde634037c60804f4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecad5dd62e89feba87740641404a5a0c6d89faabae19c23e9849a2647eb7152e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecad5dd62e89feba87740641404a5a0c6d89faabae19c23e9849a2647eb7152e"
    sha256 cellar: :any_skip_relocation, monterey:       "a43a5540b54bfb7a90226e183309b3dee8b02defff7e4aedb4c5be954760ce10"
    sha256 cellar: :any_skip_relocation, big_sur:        "a43a5540b54bfb7a90226e183309b3dee8b02defff7e4aedb4c5be954760ce10"
    sha256 cellar: :any_skip_relocation, catalina:       "a43a5540b54bfb7a90226e183309b3dee8b02defff7e4aedb4c5be954760ce10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69db649fa8161e51278d3f6f3fee05ca463aa49d0927b4b348481fdf444a743"
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
