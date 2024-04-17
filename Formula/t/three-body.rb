class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/archive/refs/tags/0.6.0.tar.gz"
  sha256 "0101dddb34244dd7e433d64ae1ca6e87a76116b5509f2b3336d5cf405961617b"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "557d72eb730f40e89c6f9ed67cdce02c995369e1a83ad35f95eb91d5e7f45288"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e90c6a2546644007942b556443a37b8d075ac9c06766b34f82da312b468deec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e2fa04cf057d27aab35b5994162e0a6d5f6a08a1e3c29ff7e46d25d0071fc2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f70fad54fd40f9d7311ed0d49a1bcb85e7960b28c58755a4d539ecf71003ab42"
    sha256 cellar: :any_skip_relocation, ventura:        "5dc936f4e4308e41bd1d8f10b67ee3616c776b6582eb8be46351dbba23ad33b4"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1c4d9311a3c2134f38a806a1f3e18b7a5c5b2afdbf255b97e6f33a4c9532f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ff936611483488d5ad9fcbfba360eed05739585e84c8d89b10ce5601213e8a"
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
