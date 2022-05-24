class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.10.1.tar.gz"
  sha256 "00c892a7cb4e847eefd36f5b8db695e184da5c090c6b509339c3b5d3a746232f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6578b886550e696ee09232115c733accf93ef81ca15eec777ebd1f97e1c0ac3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6578b886550e696ee09232115c733accf93ef81ca15eec777ebd1f97e1c0ac3"
    sha256 cellar: :any_skip_relocation, monterey:       "43dea81ca8f99cd2d6545655abbe3904990bf30a2dbbd2293d0059bdb7027e4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "43dea81ca8f99cd2d6545655abbe3904990bf30a2dbbd2293d0059bdb7027e4c"
    sha256 cellar: :any_skip_relocation, catalina:       "43dea81ca8f99cd2d6545655abbe3904990bf30a2dbbd2293d0059bdb7027e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a681c38bd47e971b82bcc4c861163e49379f55d63b71b3ce57aa3ad1c01e4cae"
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
