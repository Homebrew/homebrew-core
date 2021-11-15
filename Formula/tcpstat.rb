class Tcpstat < Formula
  desc "Active TCP connections monitoring tool"
  homepage "https://github.com/jtt/tcpstat"
  url "https://github.com/jtt/tcpstat/archive/rel-0-1.tar.gz"
  version "0.1"
  sha256 "366a221950759015378775862a7499aaf727a3a9de67b15463b0991c2362fdaf"
  license "BSD-2-Clause"
  head "https://github.com/jtt/tcpstat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4126408cb79eaf56b14fb122539a770f8c593c90576c2f23cc6cfaef2a094f54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f5880a02d97d890364b5e98871dabb0682bf1d73d43f6a2cf92f0039f29619c"
    sha256 cellar: :any_skip_relocation, monterey:       "c4a031f93d9e107740f63c329da289a7b8534d168b66326f67b3f0dc5da82e6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a8c9f2f529162b1b5fecee421aaa0c99b80864f752717142fb7f77c5f5acc43"
    sha256 cellar: :any_skip_relocation, catalina:       "86c1f5aad64e2d611dcb9d74b4eb0f51f24f79d1cdcaf636f62199099d625fa1"
    sha256 cellar: :any_skip_relocation, mojave:         "805b8444d7bcf36e2da7285474b20f5193f8e104fd990e9f87fa922bdb13801d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "164e0b5ef61bb28432b7a3d5aa23ca78d291130aa9473b9019dce643ac93bc03"
    sha256 cellar: :any_skip_relocation, sierra:         "378e42522ee14d64c0f5bf9bceeb0100c9193210eea2ee2ff80433b2b3da0166"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e483bf39d0e42a8124c3e2e50f117e66b285bada33df94c1b070460c6df622ea"
    sha256 cellar: :any_skip_relocation, yosemite:       "313fe3a9402b65b6f44b583c49ba83d301b63708b2e0a554100a5e83c03559d8"
  end

  def install
    system "make"
    bin.install "tcpstat"
  end

  test do
    (testpath/"script.exp").write <<~EOS
      set timeout 30
      spawn "#{bin}/tcpstat"
      send -- "q"
      expect eof
    EOS

    system "expect", "-f", "script.exp"
  end
end
