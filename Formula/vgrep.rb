class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v5.2.2.tar.gz"
  sha256 "5132ef6b254bfb8535b4021c297aaeafa1e641de5ab3d1ba0e1748586f97d192"
  license "GPL-3.0-only"
  head "https://github.com/vrothberg/vgrep.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94b39cbb6b11fac3e42b7c96d93ab7895118118fa0d75ecdbffba5a1e08730a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "93b8c6ed478b9fa4cd65679f0f63c19753142c681aa4d931336ae60af413318a"
    sha256 cellar: :any_skip_relocation, catalina:      "c1ea5da55551b0b8760c11aeec6b7b8adba693283cc3ae5e9d32c95cdec52f69"
    sha256 cellar: :any_skip_relocation, mojave:        "9238fc3977669ac584eeb19857b681c28fa980d28f1e163328cd30c8304ac6ce"
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
