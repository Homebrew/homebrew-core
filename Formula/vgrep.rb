class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.6.1.tar.gz"
  sha256 "61ffc1dc7445bd890a25a8bb733f7b33dc4de45388ae51c87db484def1c6f391"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11b3c10a4af215979a24aabf66547cee7351ab4e1cfe04c5ae4bd18de8e5f8ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "535140983985f51fc0aa1d4f0e2536596d8f6f621b8b051525d9e1a5297eac4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d636d0c3519f258615c5bfe6c1c5d19287e82673df0f4f9b7537a58fa255a5dd"
    sha256 cellar: :any_skip_relocation, ventura:        "7d89622548b464e5830526f96c940d478a8a2a41c856f05974ec34c0f94e150b"
    sha256 cellar: :any_skip_relocation, monterey:       "955f7b40061f709f7b6d508776ac670e5ec9a41609fd1cabae130260d2de8f6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d797ec24b06eaebcdeda87a6b1e8880f0f067428f6f35943fe0134ec4392ec95"
    sha256 cellar: :any_skip_relocation, catalina:       "df09022412dbf0ede1c3680e73466bb848c5383ea0a9e2d57476805d9d266248"
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
