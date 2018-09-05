class Roundup < Formula
  desc "Unit testing tool"
  homepage "https://bmizerany.github.io/roundup"
  url "https://github.com/bmizerany/roundup/archive/v0.0.6.tar.gz"
  sha256 "20741043ed5be7cbc54b1e9a7c7de122a0dacced77052e90e4ff08e41736f01c"
  head "https://github.com/bmizerany/roundup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5366c26e618d11f06bc85895b400a82fab81362e51dfa7dcf123fdb31aaafe75" => :mojave
    sha256 "5b8f8ba32ea5e4cf6d52e11f6b121f6ec0da11b1a0a281bf2de46431a1682f68" => :high_sierra
    sha256 "255515246130477d53aa39d0289b2840af33a937d7169a1dba297380d1eb02da" => :sierra
    sha256 "77ff95001e3a2de6eedd4d5702e5e418b7c4ecfa6855af7b479e1e978249882f" => :el_capitan
    sha256 "5dd0f6d1e64f54b3bb389411f95cd823b75e31f073e739d78793fca4b21e8e59" => :yosemite
    sha256 "42a3781280553b56fdd9330f2ef1f930b489c932ac0191313eb1cf6482e9728f" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          "--datarootdir=#{share}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/roundup", "-v"
  end
end
