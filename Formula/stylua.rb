class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "af4149a5a5733624dda6bb220a9411eff147b07ecb7c263d5dbce90a483d1df1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "609a0666a14da35aecc880024563b045f71dd64b96645bfe6fdd7f7ea2daec39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca1b4717c668639b37ba17feb11aa42ac97704af4659548fba0d4300fc4b4db1"
    sha256 cellar: :any_skip_relocation, monterey:       "2d4bd99c3d66a3d0f719e3137dd02077a1d11a12a52ed852d3b30db320ec11d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "392e20cef5ede9a77df9a22b7425e9366832026b7421d270e5ad892240a2d079"
    sha256 cellar: :any_skip_relocation, catalina:       "a4009ca78a132d7921534daa3928b2f933a6bb92ede911dbaf6c8eeafb71add2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb6a402d8c79c60d5a27ee81e7f11b8f2d6033da4822236612df101191594e1"
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
