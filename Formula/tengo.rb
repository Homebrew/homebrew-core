class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.16.0.tar.gz"
  sha256 "eb7587816ac735319795b73d0d9ad69b2a422c8530f5ece1820fbbbf9e86baa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5df19745e01c3474e66bd17f8afb9868405717256f0c7edf6d07c2cf189bfe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5df19745e01c3474e66bd17f8afb9868405717256f0c7edf6d07c2cf189bfe4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5df19745e01c3474e66bd17f8afb9868405717256f0c7edf6d07c2cf189bfe4"
    sha256 cellar: :any_skip_relocation, ventura:        "e5ec80cb4941843dceb188100ed76455b1725e1e4ede6ae0c70b5c2b2cc19ffe"
    sha256 cellar: :any_skip_relocation, monterey:       "e5ec80cb4941843dceb188100ed76455b1725e1e4ede6ae0c70b5c2b2cc19ffe"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ec80cb4941843dceb188100ed76455b1725e1e4ede6ae0c70b5c2b2cc19ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b1aa188d79affe705f0b0bfd0c70b2c89a27fc85324ded965365f75273f4c3"
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
