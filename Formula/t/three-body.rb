class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/archive/refs/tags/0.6.5.tar.gz"
  sha256 "e6c4c4039f868fce6c08adfe5852dfe15d2564ac8b9033e60bd0e098c5c5df5e"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80eaf013ad1372dff0e75a304e1a699669d19bed0d5eb9eaca11dc0563e647e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14b79b6374be096bc29c9e9f25a429c9330d1bbf42bb7228a5df22b038ccce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17906f40f4a7908537f9c3a96653a588c31d0b420bb10c7c3f98ab1a0b2a3020"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "393d8bf1e63c5818b19ffc7fddc4ed4d19fc6f727852e14a7f3406c6a2b995b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ea9365c8fb00a4cc63a309c4316bfb1b5978ea35505e0e3dcc7e8f4e3b62e7b"
    sha256 cellar: :any_skip_relocation, ventura:       "3a011425102efc7f388625413dcb9456fdb494ce9f9e19c3da548ef6637977fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c251fd07b1525f4cfa75465cc9dacad96dd2c5f0343ec9b4ccca6167c9f28d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ed8e8bf645ee93eef6d9ea9566286f8ecd54d46ebae8f2b854574edda7721e"
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
    assert_empty shell_output("#{bin}/3body -c '冬眠(1000); 二向箔清理(); 毁灭();'").strip
    assert_equal "[builtin function]", shell_output("#{bin}/3body -c '程心'").strip
  end
end
