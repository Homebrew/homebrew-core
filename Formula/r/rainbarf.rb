class Rainbarf < Formula
  desc "CPU/RAM/battery stats chart bar for tmux (and GNU screen)"
  homepage "https://github.com/creaktive/rainbarf"
  url "https://github.com/creaktive/rainbarf/archive/refs/tags/v1.6.tar.gz"
  sha256 "30d62e289177a99c07ca620dd20090caa44fc282cd1530f2383a0b4f4d37dcf8"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/creaktive/rainbarf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c31d17c562e591fd2a913a626d6a93b85674b8ca8b259495530d221eb37bac3d"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  def install
    system "#{formula_opt_bin("pod2man")}/pod2man", "rainbarf", "rainbarf.1"
    man1.install "rainbarf.1"
    bin.install "rainbarf"
  end

  test do
    # Avoid "Use of uninitialized value $battery" and sandbox violation
    # Reported 5 Sep 2016 https://github.com/creaktive/rainbarf/issues/30
    assert_match version.to_s, shell_output("#{bin}/rainbarf --help", 1)
  end
end
