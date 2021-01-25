class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.5.0.tar.gz"
  sha256 "62b7a2ced73d5ac0a183b3855d54d6619166b4d8d8c74299bb610265ccc4b193"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d39de2508929c51d9d5e8e188a1752fa72b71fc2119e1cd9edae56cfc63fbfb" => :big_sur
    sha256 "1ff7824ea9968caf95eb41e946f844a1f42026eca85aa61b5a8c76528812c8db" => :arm64_big_sur
    sha256 "0752c35a480b33fe21e6b336ebfd192b913817d649de9baf1e7d1b69e84f3a83" => :catalina
    sha256 "e9070115cff363740372b028958e590405663813526d77cfbf40b3b0abb9b9d0" => :mojave
    sha256 "9c85724a7f8272fa6fb29cd894ec78bcf4034178d88fd37cd332dec0ce34de30" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
