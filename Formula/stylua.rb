class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "ad74d1f47b0337810459dab9b49694bd5bd6c8c7381a35dcab7866752652988b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb0126bd82e1ebefcd6bf1a20f6549f174e051df538e5f38502467f72a307229"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07b7b7ccb99bee93f9e197030a597673bf19310d20abb51e2275e9bfe23b934e"
    sha256 cellar: :any_skip_relocation, monterey:       "6c76018edf651460f219c575336ef117874b6878927d8fa3a5d56f65e10fc7ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "af0868a1b8af6fb93cfafb0797527c4d0bf73873356d0d5753fcdefdd5e6e41f"
    sha256 cellar: :any_skip_relocation, catalina:       "6b7d9ad8ed998141805ee0c7f6127c12f50cf91ae966d90238bcd9e99f9abddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eecb9094cb5283a720324bde0b4e947eca8046f05876b9335efcfadc4e7b315"
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
