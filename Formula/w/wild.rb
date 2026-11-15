class Wild < Formula
  desc "Very fast linker for Linux"
  homepage "https://github.com/wild-linker/wild"
  url "https://github.com/wild-linker/wild/archive/refs/tags/0.11.0.tar.gz"
  sha256 "34d0c66c70b3c4744c548b2b821180d2d578b86eb747cb4a9ed1f4b11a95b337"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b682eb348fd7f24874e98c9937708bca43f9be40f75819f5f1a3d5fd3c23f584"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5e1cbcd3c265b8b8bf27fd462a6b02b277992bbdf724f31333f7c8cccca673d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72eb6b6236db908ff3996af57f3ed0b84b66dae822d6f9a7791e6c06b06400df"
    sha256 cellar: :any,                 arm64_linux:       "bf9973f7762f6291e134f1ed35fcf9e50a30649c0987ea3a795bebe29cf97221"
    sha256 cellar: :any,                 x86_64_linux:      "6b36947e6718c9c90e99ab7539e837f231cc104dd7432195b35183ad3eac0d6d"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on "binutils" => :test
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
