class Star < Formula
  desc "Standard tap archiver"
  homepage "https://codeberg.org/schilytools/schilytools"
  url "https://codeberg.org/schilytools/schilytools/archive/2024-03-21.tar.gz"
  sha256 "fd3db00278caecd94b3802e1f903bf235a7137511ac0a450b31d855e3a52917b"
  license "CDDL-1.0"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a02b725729e771070b0d67bfae911ec072dfebc967aee9b25cb4f87354568119"
    sha256 arm64_sequoia: "0b216c41545d4f606965e8a8210b29433c199fbf4bfa8901ea006a76d0efdff6"
    sha256 arm64_sonoma:  "f34132aeef22bddbae8c7ec9768880c13719a169c2cac815ece2a8c7667f31b4"
    sha256 sonoma:        "29f63510798acf19e36ce120edb10fdbf45cd3667d3232f8f738fc14c332de10"
    sha256 arm64_linux:   "92a7324dd76a71a12252353e4ec0856180b949d1183f68d7b58afd4cc3b2f298"
    sha256 x86_64_linux:  "e468ca1deec3dff20447934f3eef453027fab502def77e0e197ea820f2063400"
  end

  depends_on "smake" => :build

  def install
    # Disable ACL support to avoid linking an undeclared system libacl
    ENV["ac_cv_header_sys_acl_h"] = "no"

    deps = %w[libdeflt librmt libfind libschily]
    deps.each { |dep| system "smake", "-C", dep }

    system "smake", "-C", "star", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"

    # Remove symlinks that override built-in utilities
    (bin/"gnutar").unlink
    (bin/"tar").unlink
    (man1/"gnutar.1").unlink
  end

  test do
    system bin/"star", "--version"

    (testpath/"test").write("Hello Homebrew!")
    system bin/"star", "-c", "-z", "-v", "file=test.tar.gz", "test"
    rm "test"
    system bin/"star", "-x", "-z", "file=test.tar.gz"
    assert_equal "Hello Homebrew!", (testpath/"test").read
  end
end
