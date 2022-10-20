class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "5524e431a1805b7cf43587f16736643c75a00092bf302bb1f9f73e8e5d1c5a41"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f375de31e4c03d98973f982a78d3ff1430ebde66206b0d8ca70f643e1901ee0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccf1e52c6b8d80be836916c14ae52a2b8be40e0181bfa03142a97aaf9e3dd4bc"
    sha256 cellar: :any_skip_relocation, monterey:       "ce2d6926b18e45458f2a964f18626f19b0cfeec4a5f42bfd7ffc739db20c50d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "11f4e6a22480f331804e1283b23ce0dce4cff6b8ff2816b3d3b6e800069f4ae1"
    sha256 cellar: :any_skip_relocation, catalina:       "a063dbce825033f0403a7f036ee95d0ca85460b3235ae34cb9e136e25ff6590d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc1244794f483151a8d43542217bab44c3c275053142c3e055a8bb6bb7042f03"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("local  foo  = {'bar'}")
    system bin/"stylua", "test.lua"
    assert_equal "local foo = { \"bar\" }\n", (testpath/"test.lua").read
  end
end
