class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://github.com/starship/starship"
  url "https://github.com/starship/starship/archive/v0.6.0.tar.gz"
  sha256 "eec9a9f6d694bd14f1aa1e5f4a0a88c12bc4209fe52ec8f12d9dbadbef9ea32a"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "0837814004ed18507f45b4282525001c4c5e407f216f778015718a4c385a778f" => :mojave
    sha256 "013016bbacc455e2f2fde8f39e26c17786397518d35c0e01be42d749361b8a42" => :high_sierra
    sha256 "3f0f8a178891b93f61821d7c19f1bdf69e9ae8896f4625621ba6ad298b63598e" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m➜[0m ", shell_output("#{bin}/starship module char")
  end
end
