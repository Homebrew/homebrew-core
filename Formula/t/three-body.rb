class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/archive/refs/tags/0.4.5.tar.gz"
  sha256 "1e1a60f3e4320fd16f34deb53316039bc7cb17072523f34d969d6db8d668baa7"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f09cd48f95b9397bf02e57629d3670d6293084900907ec07a1267dc6040a4791"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26784fdced976da625b2e4cfd1213b0bf626350b01c0982ced55629526d7d5aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d71730792e26225683dd000aad4a6269664d9b3cac4c472664588d43dc8b6a43"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fd99db51342a6cd5cf0174e74c4b4be1c31d19b52d588d82a820f3275d71133"
    sha256 cellar: :any_skip_relocation, ventura:        "0a4314bf43ade1aa02fb1efd84ca7f9dfab716142c777c1079fcab58e463ce77"
    sha256 cellar: :any_skip_relocation, monterey:       "5e01b88b10a6ea6e654b3ef0e6aa71434925a3010a7b19505d134335527f82f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd68ee67d3fa2b10ed3c032974ba677598eb0e274207a96a406f725b43af6b90"
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
  end
end
