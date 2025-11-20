class TtySolitaire < Formula
  desc "Ncurses-based klondike solitaire game"
  homepage "https://github.com/mpereira/tty-solitaire"
  url "https://github.com/mpereira/tty-solitaire/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "8eb536a87f0586e1f057a3aa05256df34cbd92a3e22545d1df2f945e27d89db2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68978167fdbd89196ad631d75fa0e2011379fcb816213f845b158f773a71815a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a922321fcc1b9359ea8696d2cdc9b67707d0a53066bba8107a4f0038ddc63283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "781c758d098bb95bde662e5dcae67b09ccbc6b56ff68f82c1df7c45e9e06211b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce1aa6d4a70db64d2beaa2cf33af2e8509c3477a10f29d2b711e6b58759b7fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "67af4c12cfc86dcaefbf8b1dd68018c3259203ee5cd5bebb593a9d8f3097581f"
    sha256 cellar: :any_skip_relocation, ventura:       "47de6fd6466b91c5ba555ae3046e1fde2055db67092b6c8111678b58602835df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ce96af387a123810255fa0934cf9ce9dbc6fe576befef5da6c378bb1d20b5e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5612b22fbc7581b67e322b40374fd20d8ede4be785b1b38265e1ad3d94643b08"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ttysolitaire", "-h"
  end
end
