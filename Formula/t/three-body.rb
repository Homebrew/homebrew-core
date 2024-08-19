class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/archive/refs/tags/0.6.1.tar.gz"
  sha256 "ec8eda8a795608fcf187ac4ecbf3b7e6d8be80ca6cdefebf7c586837383694cb"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a28c16d9aaac1bcfedd8613deae8c20bc991748040da8c7f4e92be1b7703c86e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "192469a2ec581db2fb21910005eb950e05ed7dd3ee8110e2546605c8fc7b8dc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49986a35eae81a6e43ca80e7a84bf5de313eac163332eb3007b85e558146df59"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3c7c9e0852b7ac16d3a3bcf6befef1facf5440e27bb62c016e1b0d060306827"
    sha256 cellar: :any_skip_relocation, ventura:        "626a0c17be6e761fd133245ea759b54e7398bb1051bd2b763b7ac94a29abc9d3"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd8aa04bb52acac4dca8e5fb321e626b9a744bb936eba575aa6175a461eb349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a343096eaf0db518ad9d408e7e9be8686f6bb9a18f44597648f06b5601644237"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "\"文明\"", shell_output("#{bin}/3body -c '给 岁月 以 \"文明\"; 岁月'").strip
    assert_equal "\"生命\"", shell_output("#{bin}/3body -c '给 时光 以 \"生命\"; 时光'").strip
    assert_equal "Error(Can not assign to constant variable 水!)", shell_output("#{bin}/3body -c '
      思想钢印 水 = \"剧毒的\";
      水 = \"?\"'").strip
    assert_equal "4", shell_output("#{bin}/3body -c '给 自然选择 以 0; 自然选择 前进 4'").strip
    assert_equal "3", shell_output("#{bin}/3body -c '给 宇宙 以 { \"维度\": 10 }; 宇宙.维度 降维 7'").strip
    assert_equal "true", shell_output("#{bin}/3body -c '这是计划的一部分'").strip
    assert_equal "false", shell_output("#{bin}/3body -c '主不在乎'").strip
    assert_equal "3", shell_output("#{bin}/3body -c '
      给 水滴 以 法则() {
        给 响 = 0;
        return 法则() {
          响 = 响 + 1; 响
        }
      };
      给 撞 = 水滴();
      撞();
      撞();
      撞()'").strip
    assert_equal "\"半人马星系\"", shell_output("#{bin}/3body -c '给 三体世界坐标 以 \"半人马星系\"; 广播(三体世界坐标);'").strip
    assert_equal "", shell_output("#{bin}/3body -c '冬眠(1000); 二向箔清理(); 毁灭();'").strip
    assert_equal "[builtin function]", shell_output("#{bin}/3body -c '智子工程'").strip
  end
end
