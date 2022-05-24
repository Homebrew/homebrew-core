class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.6.0.tar.gz"
  sha256 "4cbd912189397b08897fcc1709787ec60ed42275059f900463055211e1f6d689"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/vrothberg/vgrep.git", branch: "main"

  # The leading `v` in this regex is intentionally non-optional, as we need to
  # exclude a few older tags that use a different version scheme and would
  # erroneously appear as newer than the newest version. We can't check the
  # "latest" release on GitHub because it's sometimes a lower version that was
  # released after a higher version (i.e., "latest" is the most recent release
  # but not necessarily the newest version in this context).
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba320fea76d46597b5cb1d750ad03e56d1e8481264f12f906ca33092d7f3fb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d0d068dfb51958e4327d4b453e9effda29915a8902e8c2aefef2324751b25af"
    sha256 cellar: :any_skip_relocation, monterey:       "c59e5f9cdc3b7f49631f85ed5e24f4ac6e6e9aa31b950a572d33081a84415ece"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ee5a3d20e1d70cf4e0de278b8fa4149ca8195a3fd1afb0eb39f463c7a6f9868"
    sha256 cellar: :any_skip_relocation, catalina:       "199a9605dfc3964c6ccdd94bd4c2f1b7e4b4fba2850a935a7aa31c87879f5ed3"
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
    assert_match "Hello from", output
    assert_match "Homebrew", output
  end
end
