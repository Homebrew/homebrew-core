class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.12.0.tar.gz"
  sha256 "d74f551194d141f36c7314f2286eea7f2bc92acdd47bd11c7df5186f15f25fc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8687496109f25a23df973154ee7a7cdcb7171038aeb995380ca146cd092f54cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8687496109f25a23df973154ee7a7cdcb7171038aeb995380ca146cd092f54cc"
    sha256 cellar: :any_skip_relocation, monterey:       "02b0c4cb0e5b3dbcd57de40d4bedbc63b9ac76a10f431a457fbde7f9a73b7e7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "02b0c4cb0e5b3dbcd57de40d4bedbc63b9ac76a10f431a457fbde7f9a73b7e7f"
    sha256 cellar: :any_skip_relocation, catalina:       "02b0c4cb0e5b3dbcd57de40d4bedbc63b9ac76a10f431a457fbde7f9a73b7e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eefd6543d3e3404aa39b2e6e5fb79f14345872a1f2e7cde2b49ce15fef795b4"
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
