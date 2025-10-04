class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "e1dfdae2fcbeeae60d1e25102d1845a09501e0afa98a7d31f1e8a4f636695adc"
  license "MPL-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1230bebcfe854066901fbb286e7fec71dfad774f4b8ca4f965caaed26cffa98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcbae5529a7cb686e7c86b257fb042ba00e8bc3adbb04a5e7d6c089bd94d8c99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6976df32f2e306e0eb65f28abd48e2adb4542732efabf119ed90871b8b48e549"
    sha256 cellar: :any_skip_relocation, sonoma:        "2da7406784b47eb720cc8f8bbaecd69f5adc35d79500f2aa2caab377b86ef27d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c672f50b1525a63719ba3803344d695085b54c0850f7ccbb7b1aa09fd3e44da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e249544eec070a1d11f5429a1948ab74b2fd07398bfc1ccc95ba64dbbee02661"
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
