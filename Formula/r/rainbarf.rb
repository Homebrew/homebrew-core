class Rainbarf < Formula
  desc "CPU/RAM/battery stats chart bar for tmux (and GNU screen)"
  homepage "https://github.com/creaktive/rainbarf"
  url "https://github.com/creaktive/rainbarf/archive/refs/tags/v1.5.tar.gz"
  sha256 "5fc96ffc16929e2158e82baf2a39f5573e6013a280ad66067e1eaee594be98df"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/creaktive/rainbarf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38468e83f62fd6e59c5647e82ce310682b08cf33b1bf9cb20275b6a078b7c53a"
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
