class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "d1159a07f642852d4fb63721dd8b048123ed8de92a9b4b89e3391a4811793f7f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69cbe97e26baca69711f13b08f81f2fe1914f759373573348da4c34fd9a56dec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2889a8b862bdce6d9c77c64ef41e5002de16c6e1055da2eace7fc7435e110b0"
    sha256 cellar: :any_skip_relocation, monterey:       "afc8ae23ed69eee2110d29eeb9b04fa85489e3c29a42a2e06fcd357dc181b2d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a4d8b3d1420d463de430e7ae337a77ae68db9d8d84daabe8a2ad0c0905b828"
    sha256 cellar: :any_skip_relocation, catalina:       "27a302c7e0ac20e845175affe9ca5bc38c1d29da6ff09f0b3a81d6596ca327d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d3610fc0c36b3ec3ae64a1e50bdea6e677cb66b67a6f9dbcaa162f2de03ca5"
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
