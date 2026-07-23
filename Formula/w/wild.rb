class Wild < Formula
  desc "Very fast linker for Linux"
  homepage "https://github.com/wild-linker/wild"
  url "https://github.com/wild-linker/wild/archive/refs/tags/0.9.0.tar.gz"
  sha256 "f70ac025d158fd2c41be8f895a90a8f39b8b89fefbbb8ad5f45441f57b80156a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb3ffb44608992713f44ff108a8a3cec15b93959fe1d5827b89a98591bd7884e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f59b64ae99386954ab2ca228e199a06530f3ee2ce8f6e48534e168d1f6fee77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4718b235c3a6e16953f7ed2bb6c0c42befa87f28a0fd1e7e40624e90b929cce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "29fe9023e19b56cbc7d11a5dc6d779c7dfbaaa2f664e487934d13018c62637ed"
    sha256 cellar: :any,                 arm64_linux:   "f849805d7e65b683ca759ec9ab4876e33b8ed2fc478353056c1e41e6abfaf1bb"
    sha256 cellar: :any,                 x86_64_linux:  "ec382a40a394d0fd320dee1cbec2eb7a44fffc609f29cb761692104080779c3c"
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
