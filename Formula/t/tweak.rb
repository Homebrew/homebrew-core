class Tweak < Formula
  desc "Command-line, ncurses library based hex editor"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/tweak/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/tweak/tweak-3.02.tar.gz"
  sha256 "5b4c19b1bf8734d1623e723644b8da58150b882efa9f23bbe797c3922f295a1a"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?tweak[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cd057cbf1a867eb44bdb3754dd80b9332866977d6fa19c6ecffd35e11df4f5cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bf452cf3fc91bce4ad69ee5bea2c8485c80aac9efad963b3492cd10d2eb83619"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7696232f907f0fb9d98fdd2b1fbff035fddfa50180f63b0edef3c556f8b0aeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71052661cea0d22a4808275349d795438ae29ecee01aa145e0d0cef0214e6642"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7fd74395285898f8a5d187c349de12b3cdb658b3b613e0dde445e1c679de808"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5688f682787ca49543c2a6bed37237fc52c4ecd11707ec7d5688eaa60e9bf21"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f735e94f919b22d47f9ed92dc74cace693042f6f3c01ad2910c0ff1241c9bd1"
    sha256 cellar: :any_skip_relocation, ventura:        "f124b1cff60dee61f0128c440f647f34e8b38bedc1b9120b822a5a3b50e4c2c8"
    sha256 cellar: :any_skip_relocation, monterey:       "398bfc5cdc33b289dd14f243ba00a3bfc9281878588fd2995931931e87dfdeb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "db84e159f437b7ba3c6592ee9564842e6d21823325777c2317acdda483d452bd"
    sha256 cellar: :any_skip_relocation, catalina:       "a38441e05b3953b324cee772161ebb1ccf12bf2262c476af921fee963fdee413"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5e1f2f53b18e654221c1d61699c1e766fe53d5df15add6ef0b4aac050ea7b618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b7907316240a0b5efb6a1025c22664da20e509d1d7d9787a7bdaa060d4c06f"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    output = shell_output("#{bin}/tweak -D")
    assert_match "# Default .tweakrc generated", output
  end
end
