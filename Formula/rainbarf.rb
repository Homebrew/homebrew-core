class Rainbarf < Formula
  desc "CPU/RAM/battery stats chart bar for tmux (and GNU screen)"
  homepage "https://github.com/creaktive/rainbarf"
  url "https://github.com/creaktive/rainbarf/archive/v1.4.tar.gz"
  sha256 "066579c0805616075c49c705d1431fb4b7c94a08ef2b27dd8846bd3569a188a4"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/creaktive/rainbarf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a149026ada66d61e40b18aac888eb0502cd0d63b539116761cdd559949ceb14b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a149026ada66d61e40b18aac888eb0502cd0d63b539116761cdd559949ceb14b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef63dec71481ba7ea8f46ebe302945b5d09845825dde684183a2cf2bc65c3684"
    sha256 cellar: :any_skip_relocation, ventura:        "a149026ada66d61e40b18aac888eb0502cd0d63b539116761cdd559949ceb14b"
    sha256 cellar: :any_skip_relocation, monterey:       "a149026ada66d61e40b18aac888eb0502cd0d63b539116761cdd559949ceb14b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef63dec71481ba7ea8f46ebe302945b5d09845825dde684183a2cf2bc65c3684"
    sha256 cellar: :any_skip_relocation, catalina:       "cc3cc692fe18a6c757c92ed7c251a2b23dc04df3d2e88acd30fc776620cd8059"
    sha256 cellar: :any_skip_relocation, mojave:         "cc3cc692fe18a6c757c92ed7c251a2b23dc04df3d2e88acd30fc776620cd8059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4ef99243fcd96fe02779e6261d3301dbc7e6b20338c84337ec516e1587e56c"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  def install
    system "#{Formula["pod2man"].opt_bin}/pod2man", "rainbarf", "rainbarf.1"
    man1.install "rainbarf.1"
    bin.install "rainbarf"
  end

  test do
    # Avoid "Use of uninitialized value $battery" and sandbox violation
    # Reported 5 Sep 2016 https://github.com/creaktive/rainbarf/issues/30
    assert_match version.to_s, shell_output("#{bin}/rainbarf --help", 1)
  end
end
