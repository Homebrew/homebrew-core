class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "aba628d721380290a334ae899eff1aec9d3d14302d2af336f67d8d7af72d35e3"
  license "MPL-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1597ee54ad9e607752a66e3bad99ab26839ce575468a406a3bfbfde7f6fa1056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f44eddfe0d4986833deeec3528f303375aaccd2be80fa75432bfccee9d44f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23e29821ccf2d1ee7f8904d2f4895dae21ede0592a750253d788f72f48bfab52"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d61c386eedb3ff943f9ea44800f929707d8f5d1b5115b2cdd839451cd3e668d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cf767901f53af735ec938638824b2790fda1644fba069ee92639203cb8498f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44015fc651e0c1bcc804f9b021c1d01b33c755fec4988c5c779bd03c4e51399a"
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
