class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.5.1.tar.gz"
  sha256 "7516d16d87c118c081f43ec74e091d02c194afa984e7dc63a46cb24b149896c4"
  license "GPL-3.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ba0b220e0e1e204c54685f83bf0b2e8bf6922b95c0833c68b6fa116c857f6281" => :big_sur
    sha256 "d7347207e722a5edac6595fce5baa9f64a1bcd10d310d25c62517e88c0c125fb" => :arm64_big_sur
    sha256 "c7ef6771646891c23fff3120f0a8b3075abaeb13540e57a89ee81d46ae4f2e81" => :catalina
    sha256 "a4d5cc61d723389a58dd952b1d9caad009948983c11899e8d8adb79418e814ee" => :mojave
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "release"
    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less .")
    assert_match "Hello from \e[01;31m\e[KHomebrew\e[m\e[K!\n", output
  end
end
