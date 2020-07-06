class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.44.0.tar.gz"
  sha256 "b002fa0e2b34ad59330a543461a51648751db4ae8d439d58065a3b9656772fe3"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b421825645ddabfdb25559d2db0293fff3823c00d42e56343fd80a103ece3879" => :catalina
    sha256 "ca22a2ed29177cebaeae173fb783c4c66448582f1ab8becc847276c1c3b9eb6d" => :mojave
    sha256 "76f716ed29e6fbb85a5342ff36e6d0af4d14d35a7fec513a72e2b8d57fe30465" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
