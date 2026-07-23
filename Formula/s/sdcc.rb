class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/4.6.0/sdcc-src-4.6.0.tar.bz2"
  sha256 "5fd6a93e5997ce01756868fe35e441095cfb637894a80c262514a634094973b6"
  license all_of: [
    "GPL-2.0-or-later", # sdcc, sdcdb, ucsim
    "GPL-3.0-or-later", # sdcpp, sdas, sdld, sdbinutils
    :public_domain,     # packihx
    "Zlib",             # makebin
  ]
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  livecheck do
    url :stable
    regex(%r{url=.*?/sdcc-src[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "300fb3c8599a5f4c00cfdec9e12750f09ccca484b7cbbcaa6bc378512a8a0cf7"
    sha256 arm64_sequoia: "8fd0fe168465571181215aaca52df741fa770071881dac56e4409d9a668463c7"
    sha256 arm64_sonoma:  "2635b27f7410f33954cea1a595576b658ed11e2b888a1cf828938222399cdcc8"
    sha256 sonoma:        "9424f0ad933b46ecae302cc0062c256c9d7cb832d5c67cb7f22d710f90760d30"
    sha256 arm64_linux:   "a04ebca614af7c5a528d9c429a74cdfbbd4706034fb446bb21a6be8810eb4187"
    sha256 x86_64_linux:  "23029b2b9a02accdb1dd405874997d5a35b109ade0be43c3d89c0a9707bae85a"
  end

  depends_on "boost" => :build
  depends_on "gputils"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "zstd"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-non-free", "--without-ccache", *std_configure_args
    system "make", "install"
    elisp.install bin.glob("*.el")
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C
    system bin/"sdcc", "-mz80", testpath/"test.c"
    assert_path_exists testpath/"test.ihx"
  end
end
