class Sqtop < Formula
  desc "Display information about active connections for a Squid proxy"
  homepage "https://github.com/paleg/sqtop"
  url "https://github.com/paleg/sqtop/archive/refs/tags/v2015-02-08.tar.gz"
  sha256 "eae4c8bc16dbfe70c776d990ecf14328acab0ed736f0bf3bd1647a3ac2f5e8bf"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8850e7822e47d6a8371e31210542a776644252960fe3cfdbc3a348563d047d4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "86fa975d403a9957261b33b293324908d327eff19831b705463866a7a4ccad2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beff07169db5be764d18cb3bee9a18371d130c6cb3d2e8890e41b460c6e0f55e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31df54161ef5a2bca073d0aa08c9954763fb41721ece41ded2c7c630788c67c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1c485dad29e5a373c5d6a973a7c36cf2de7bbecc44e07bb715b126e9fe0ea1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4d9ab76457599f2fe20875e9900c1d1f330ba7b35d4383e99042b66b264de3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0eaaf8009ba705393183cfe4a2d4bb0a0eab311fe5cf5e20e72058c88f4665f"
    sha256 cellar: :any_skip_relocation, ventura:        "7ada919a0dfa2421cdb0a0234a4a16db5530b56c56869e6dde7e5a0c0ccecbb9"
    sha256 cellar: :any_skip_relocation, monterey:       "783650fd010e84cba76c1d747d7948fa1ccf0ae17032e797d76920b291ff36a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "236b80d46f0cbc8aedc14b6771b4b58cff6e445eb2e8a115ae14917b307fbab2"
    sha256 cellar: :any_skip_relocation, catalina:       "653be227eb16e647b90f0f034543a490476e3ceaa0e9c165b1963b916b4a9703"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "02d8d356631939d3201e72c24a96353e5032ddd6abfe1613cd7ac07de0720dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7bd15bf5407710e19ab7c3bd414c18b163b251274d14e058208a526353a7e0"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqtop --help")
  end
end
