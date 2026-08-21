class Wild < Formula
  desc "Very fast linker for Linux"
  homepage "https://github.com/wild-linker/wild"
  url "https://github.com/wild-linker/wild/archive/refs/tags/0.10.0.tar.gz"
  sha256 "99ec83404558d4d0cbde9dd44b8c6fa2a511a2f8bb04a31f54c0929ec4491990"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ab41b1dee478c039b6460075d6ce04996821a459d2ca25336e4b3274dba1501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2f9e80db085e85dcfc28aa057f776257b817fa7b8ee46979d67ebdea3514b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf97fa493f4bc9a8ab64dcda39058384adc9fed7337aa9d54d73e9b34a13970"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e2c75eafd8a76183d9aa80b20f2ac779de1b4e71a2658791b49f0751777b1a"
    sha256 cellar: :any,                 arm64_linux:   "ba3a468b4493c82c9ebb6ba8da2e6006d3fd864578dcad51e5e43a650d120769"
    sha256 cellar: :any,                 x86_64_linux:  "7a92cd557a2bc64dbc543f91bbfb6241386f18ed5f34d6ce0a380bbd89e76f12"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on "binutils" => :test
  end

  def install
    system "cargo", "install", "--profile=dist", *std_cargo_args(path: "wild")
    bin.install_symlink "wild" => "ld.wild"
  end

  test do
    (testpath/"test.c").write <<~C
      int main(void) { return 0; }
    C

    linker_flag = case ENV.compiler
    when /^gcc(-(\d|1[0-5]))?$/
      # https://github.com/wild-linker/wild#cc-autotools-cmake-meson-etc
      (testpath/"wild").install_symlink bin/"wild" => "ld"
      "-B#{testpath}/wild"
    when :clang, /^gcc-\d{2,}$/ then "-fuse-ld=wild"
    else odie "unexpected compiler"
    end

    extra_flags = %w[-fPIE -pie]
    extra_flags += %w[--target=x86_64-unknown-linux-gnu -nostdlib] unless OS.linux?

    system ENV.cc, linker_flag, *extra_flags, "test.c", "-o", "test"
    if OS.linux?
      system "./test"
    else
      assert_match "ELF 64-bit LSB pie executable, x86-64", shell_output("file test")
    end

    readelf = OS.mac? ? formula_opt_bin("binutils")/"readelf" : DevelopmentTools.locate("readelf")
    assert_match "Linker: Wild ", shell_output("#{readelf} --string-dump .comment test")
  end
end
