class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/archive/refs/tags/0.6.3.tar.gz"
  sha256 "bcdf74ac50c9132e359e6eed1e198edc5db126be979608849dd410460e822aac"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c86e0b06c8e264a8a7ae0d33591c69380625989bc1aec6c4a0727cc216f95fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ae4e7e9acafbfe587790151944084e09afeafa43415555567fbe9c817dbcfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "131aa9b76e07145d6588677be7d671ead9dd935197c3beab53e2f591d7a6d17f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e14620a0ad363e7dec91f812f786f76f7a8065ca39a209e00b9d816c961fb6cd"
    sha256 cellar: :any_skip_relocation, ventura:       "b9b8a2d05f18d2a9c7ea644127975c7ff746430fe3b86d9791fa273aeeab0151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0304bbd3d0106edee56473df768b6bef99ee07c5a17b85e8b4d3333e7a2333fa"
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
