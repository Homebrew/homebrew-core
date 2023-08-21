class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.16.1.tar.gz"
  sha256 "e8af90295be400f89455f6fc3200cedb29b94d834b95df22ffbc7c6afc28829e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed7681ae6640ac4275366f3a232effe41f60748ccf9e7d105f683cc4ba565c32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed7681ae6640ac4275366f3a232effe41f60748ccf9e7d105f683cc4ba565c32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed7681ae6640ac4275366f3a232effe41f60748ccf9e7d105f683cc4ba565c32"
    sha256 cellar: :any_skip_relocation, ventura:        "d4ca14c1c1ea057f4b242b0df344092556dbd30c3db33823cd99e9dd71c16dcf"
    sha256 cellar: :any_skip_relocation, monterey:       "d4ca14c1c1ea057f4b242b0df344092556dbd30c3db33823cd99e9dd71c16dcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4ca14c1c1ea057f4b242b0df344092556dbd30c3db33823cd99e9dd71c16dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "367ce9e8f36e6adf7718153618d44c84ff8fe111f85583b2682182b727d57097"
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
