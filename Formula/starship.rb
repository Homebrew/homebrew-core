class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.16.0.tar.gz"
  sha256 "eadf8fc68134ed3c23b558ea0b6701054149ae23d9149613dfc8bed28cc7173d"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "998ace27edf7926741168c3f7bb35503709a7a4046cccbaec1a283bbe31ac611" => :mojave
    sha256 "829e17ff01ba74a13d05ee137d9b9594105ead917f0057d57d2f6195b9e0f435" => :high_sierra
    sha256 "bb6a290c10cadf29972414bdf440fc3d2cd5256a9f0ccc0cd66c19d7a08c6940" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
