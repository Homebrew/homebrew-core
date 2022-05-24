class Roundup < Formula
  desc "Unit testing tool"
  homepage "https://bmizerany.github.io/roundup"
  url "https://github.com/bmizerany/roundup/archive/v0.0.6.tar.gz"
  sha256 "20741043ed5be7cbc54b1e9a7c7de122a0dacced77052e90e4ff08e41736f01c"
  license "MIT"
  head "https://github.com/bmizerany/roundup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "686cc922ad95b85a419eea991cb2320b9971b38233131934ca95cb5467d9e264"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a2445d10704dfbc5e90afd6414b919b78cd116d645cd1a72e69200c976c92cc"
    sha256 cellar: :any_skip_relocation, catalina:      "ce6d6747b6a2fc94f05de03ddd4dd1c7a77764253a6f61163a24be1626f8b7be"
    sha256 cellar: :any_skip_relocation, mojave:        "5366c26e618d11f06bc85895b400a82fab81362e51dfa7dcf123fdb31aaafe75"
    sha256 cellar: :any_skip_relocation, high_sierra:   "5b8f8ba32ea5e4cf6d52e11f6b121f6ec0da11b1a0a281bf2de46431a1682f68"
    sha256 cellar: :any_skip_relocation, sierra:        "255515246130477d53aa39d0289b2840af33a937d7169a1dba297380d1eb02da"
    sha256 cellar: :any_skip_relocation, el_capitan:    "77ff95001e3a2de6eedd4d5702e5e418b7c4ecfa6855af7b479e1e978249882f"
    sha256 cellar: :any_skip_relocation, yosemite:      "5dd0f6d1e64f54b3bb389411f95cd823b75e31f073e739d78793fca4b21e8e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2549ae6529389a3b88e83126f39ea6accb7a47321da5a90b7edb7115ed1161d"
    sha256 cellar: :any_skip_relocation, all:           "c5406062d942983953655e151bcd83de2766b5507f16343095cbdcefe3e4ceee"
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
