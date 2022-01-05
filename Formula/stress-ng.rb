class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.10.tar.gz"
  sha256 "972b429f9eb0afbceabf7f3babab8599d8224b5d146e244c2cfe65129befb973"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44092ac28b582aa2e34821b69ac6f55ab9e3972d27cd05d8764cafe2eaa4eb33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8a2a6b7f189bc578bacda248dbffa7175f55ed22c8cc09cbb49cc7319ccd53c"
    sha256 cellar: :any_skip_relocation, monterey:       "da16e9ef1b9add9f759fdac1582e08e8a424f3af625096bb691ae35cff798292"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a9e8a806930f762e3d7ffb239eca73ac99bf3d41e3171af7ae0cc2d5c984583"
    sha256 cellar: :any_skip_relocation, catalina:       "ef9fcf074157521b1554497c9b122725a73fe9a253551bea845f60affd71c4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7eb794e09f03be1be0b906465657444fef88e26a2f70a5f0dbccd31dc69b81"
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
