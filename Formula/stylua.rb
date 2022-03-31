class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "ad74d1f47b0337810459dab9b49694bd5bd6c8c7381a35dcab7866752652988b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6dae3cac8eb280ead7da707f0cd4e9082dc4e40aa8e5455e781692125d12a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5900c886e94d6b176db963604cafcd86f6ecb2296dbd00e8abf1dbacda109497"
    sha256 cellar: :any_skip_relocation, monterey:       "88fde4396bc1b167a75f2ba8f863531df91d40f5e9e5c316ec9fb56db1b51d01"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d3924f9d36a92d97eb16cbcde0ea487ab91f8f6f0c2b2b592aed082230778f0"
    sha256 cellar: :any_skip_relocation, catalina:       "d5b2ba2aecfc1f2a45368d58718e37ba98b3072c45e3678a11b1eaf5255adb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9720c2caedbf6072e91ac1c2af2955f76e68a6735f437106e15846c3053204c1"
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
