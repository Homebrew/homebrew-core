class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/releases/download/0.3.1-rc.0/3body-lang.tar.gz"
  sha256 "8d001d162df7b926d457fdb6f27385cfbac45df43fad145893d02514c3b02c8a"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d12b9f985a0dbfb35785042bf5ae999e7009a535d84a5ddbfc23cf99de94ec4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49e781eb7eaa2354761c4f326bf1c8c5ff2fe0dc3dc0c76d0858ddeb02e0981d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84f8c528b0f1b59628f20741da8463fb75e415be193c3d853d2ac2c559123e4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b728b0182eb9153c014cd2eec2199eaf4824d3e6eff09d4a86f006311ed6660a"
    sha256 cellar: :any_skip_relocation, ventura:        "dca97388115f745f493904858a83a199e38ef26b4383f26e10738d88bc6c3d14"
    sha256 cellar: :any_skip_relocation, monterey:       "ec971e96f996bda26bd926dc4f025142c41e9f344796382838376065ec40b2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6e01658f4820de0aace31f67b81fd4c34fc0b7b24992afd8b89124c5000435"
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
