class X8664ElfGcc < Formula
  desc "GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  sha256 "50efb4d94c3397aff3b0d61a5abd748b4dd31d9d3f2ab7be05b171d36a510f79"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "b0a749d5dd0f8652f574a129f7676f0bb7640582075bc7e84b7a280b9c333f48"
    sha256 arm64_sequoia: "d6a74b2455d68c12bfcb338608d9dd4193b6d2429db99e2f755990c1443bf9ea"
    sha256 arm64_sonoma:  "d4051c15a08edd4700fb60bc9ec3041eab7adef9efcde6f36bfb7625d3e07af9"
    sha256 sonoma:        "17194b453b702517efeb58653a77835f400eec54ddea2d0f5637335efb3f8522"
    sha256 arm64_linux:   "34e47b9a5f3a59824010feed78d19fbd312126ab3616cd0f3f354a2c3a127e46"
    sha256 x86_64_linux:  "f001f7ca76fef4802a454db1ae144debc648c3f657dd37c6b622cadbe473c56d"
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "x86_64-elf-binutils"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "x86_64-elf"
    mkdir "x86_64-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-as",
                             "--with-ld=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-ld",
                             "--with-system-zlib",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      rm_r(share/"man/man7")
    end
  end

  test do
    (testpath/"test-c.c").write <<~C
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    C

    system bin/"x86_64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    output = shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-c.o")
    assert_match "file format elf64-x86-64", output
  end
end
