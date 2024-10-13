class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "9402666c9c6f70b21e16c6e75983282ae127a47c854fc7aee9fd8ad3ffb1c550"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7a5bbb578e2f5d322fdb80fe528d869fca27c9145c5c00377160ca9d4e4819a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b7a37df6e267c27b3e50d42b20c104e71555ad51dcc7bed28a248154521ab5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b7a37df6e267c27b3e50d42b20c104e71555ad51dcc7bed28a248154521ab5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b7a37df6e267c27b3e50d42b20c104e71555ad51dcc7bed28a248154521ab5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "edd5efc7a30b373a94f70fea5f100fa7bb62fb6fa99ff405a4efa877d402ea60"
    sha256 cellar: :any_skip_relocation, ventura:        "edd5efc7a30b373a94f70fea5f100fa7bb62fb6fa99ff405a4efa877d402ea60"
    sha256 cellar: :any_skip_relocation, monterey:       "edd5efc7a30b373a94f70fea5f100fa7bb62fb6fa99ff405a4efa877d402ea60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d3b58976ba432890479463deb0101ee5ca3a225cfb39354463fc85ce005d227"
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
