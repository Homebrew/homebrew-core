class Rainbarf < Formula
  desc "CPU/RAM/battery stats chart bar for tmux (and GNU screen)"
  homepage "https://github.com/creaktive/rainbarf"
  url "https://github.com/creaktive/rainbarf/archive/refs/tags/v1.4.tar.gz"
  sha256 "066579c0805616075c49c705d1431fb4b7c94a08ef2b27dd8846bd3569a188a4"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/creaktive/rainbarf.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4787b85e42e62b921b5729449bc86ba7ac7accdb165bf20a8f2a43e190dd2173"
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
