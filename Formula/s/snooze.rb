class Snooze < Formula
  desc "Run a command at a particular time"
  homepage "https://github.com/leahneukirchen/snooze"
  url "https://github.com/leahneukirchen/snooze/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "abb0df288e8fe03ae25453d5f0b723b03a03bcc7afa41b9bec540a7a11a9f93e"
  license :public_domain

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b939563950d008b7b55c180cfbca14a881ec02bea69c305d52b6ae9beaa572a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a242f88d5027b13edbaf3aa5bada7121f8bbe239dcb2aa4200fbb277d017fcd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "574501024e100924970d083d8e18c99ac857a491513e5c5a3a2ac7328e29b626"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbeda0b945fd00cd421ff125ad342fde3d205a00251a263ffca5acbc332fe4e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a32859378d3d23ceed3b0174af3fbbcbffc727acb2dc191507e2229dc864bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a636a409a86b9d904cf1d8a5e8aa9fc7ee94fc2015308daf907413200e8f63"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "T00:00:00", shell_output("#{bin}/snooze -n")
  end
end
