class Yetris < Formula
  desc "Customizable Tetris for the terminal"
  homepage "https://github.com/alexdantas/yetris"
  url "https://github.com/alexdantas/yetris/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "720c222325361e855e2dcfec34f8f0ae61dd418867a87f7af03c9a59d723b919"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "20e107c4ccac64993e5c8f794bc50299d759df2b0b9badab5d0a5ec2708cfc04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b5358a7a07d701232e1a75a4b28f2e66879d973ef3eb9c848552347505f16ea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c29c804faf6d9d78ecec1eeccc4ffe85e94550c222bba9e793e307f805c1d97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bde6f3b8d260bc2b35e850b59223578400c2fda5e97e1ef4b425eb446f9b68b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aa127e1a907e08cf4b65d83fe0de8c59785457f744ecc2c1e91fd37310037b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcaafa1c4c02615a805d252ce93cf8c38a60876b575867cc280795a00a1f2848"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ccd8bfcdeb653c72ebfb085887255edba5547412e29462eb72b9c395257e4a7"
    sha256 cellar: :any_skip_relocation, ventura:        "c1d76e812f2a403dd078b3a0b075b48a21721c629b94b4be83874147b3f4b787"
    sha256 cellar: :any_skip_relocation, monterey:       "78e274470e8eb080f6d8c7d0051f4e7f0ee7f7969c88c725a114b39b7f926778"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d9c0ddd6f7f825024cb4e96978ad43919eb77a216e8788943f1c8d7bfa80bb"
    sha256 cellar: :any_skip_relocation, catalina:       "a43b346adc20fc7d4f84ec1300e839bb4e615ab40ccf8e1a591f099092ad6078"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2f5e4bda0d6d949df4cb5b4fa0bd5adb552ec9752e34cbf9f7c106342877f108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d2652ce4673ff9e663dba05e742ff8d0eff4366216c49a051d94df041498a2"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/yetris --version")
  end
end
