class Retro68 < Formula
  desc "GCC-based cross-compiler for classic 68K and PPC Macintoshes"
  homepage "https://github.com/autc04/Retro68/"
  url "https://github.com/autc04/Retro68/archive/v2019.8.2.tar.gz"
  sha256 "5ef015d28be868abe397404d66b8feb67c2793dedf4da12ac0048545f333ef61"

  depends_on "boost"
  depends_on "cmake"
  depends_on "gmp"
  depends_on "libmpc"

  resource "mpw" do
    url "https://staticky.com/mirrors/ftp.apple.com/developer/Tool_Chest/Core_Mac_OS_Tools/MPW_etc./MPW-GM_Images/MPW-GM.img.bin"
    sha256 "99bbfa95bb9800c8ffc572fce6d72e561f012331c5c623fa45f732502b6fa872"
  end

  resource "interfaces_and_libraries_sh" do
    url "https://raw.githubusercontent.com/autc04/Retro68/v#{Retro68.version}/interfaces-and-libraries.sh"
    sha256 "b930d0fdf92528e63a18ac9115df5658241575a0e3b904b4781ae68f7516564e"
  end

  resource "prepare_headers_sh" do
    url "https://raw.githubusercontent.com/autc04/Retro68/v#{Retro68.version}/prepare-headers.sh"
    sha256 "790a27ba6613a173450a6a2d94275efea22b7f0c086b0e0eb1fbf61d200b1c3c"
  end

  resource "prepare_rincludes_sh" do
    url "https://raw.githubusercontent.com/autc04/Retro68/v#{Retro68.version}/prepare-rincludes.sh"
    sha256 "984db9e01451aa9bf1e40dadf8a88b82286b03b9998bec5a57a10e2735e86c46"
  end

  def download_interfaces(dst)
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("mpw")
    chdir tmpdir do
      system "macbinary", "decode", "MPW-GM.img.bin"
      system "hdiutil", "convert", "MPW-GM.img",
                        "-format", "UDRO", "-o", "MPW-GM"
      system "hdiutil", "attach", "MPW-GM.dmg"
    end
    src = "/Volumes/MPW-GM/MPW-GM/Interfaces&Libraries/"
    dst += "/"
    cp_r src + "Interfaces", dst
    # cp_r does not copy resource forks.
    # rubocop:disable FormulaAudit/Miscellaneous
    system "cp", "-r", src + "Libraries", dst
    # rubocop:enable FormulaAudit/Miscellaneous
    system "hdiutil", "detach", "/Volumes/MPW-GM"
  end

  def install
    download_interfaces "InterfacesAndLibraries"
    mkdir "build" do
      system "../build-toolchain.bash", "--prefix=#{prefix}"
      # Apple's interfaces and libraries may not be redistributed and therefore
      # cannot be part of the bottle.
      system "../interfaces-and-libraries.sh", prefix, "--remove"
    end
  end

  def post_install
    # Apple's interfaces and libraries may not be redistributed and therefore
    # are not part of the bottle.
    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("interfaces_and_libraries_sh")
    tmpdir.install resource("prepare_headers_sh")
    tmpdir.install resource("prepare_rincludes_sh")
    chdir tmpdir do
      mkdir "interfaces"
      download_interfaces "interfaces"
      system "bash", "interfaces-and-libraries.sh", prefix, "interfaces"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write "add_application(Test test.c CONSOLE)"
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(int argc, char** argv)
      {
        printf("Hello");
        return 0;
      }
    EOS
    cmake_files = [
      "#{prefix}/m68k-apple-macos/cmake/retro68.toolchain.cmake",
      "#{prefix}/powerpc-apple-macos/cmake/retrocarbon.toolchain.cmake",
      "#{prefix}/powerpc-apple-macos/cmake/retroppc.toolchain.cmake",
    ]
    cmake_files.each do |cmake_file|
      mkdir "build" do
        ENV["CFLAGS"] = nil
        ENV["CPATH"] = nil
        ENV["CPPFLAGS"] = nil
        ENV["CXXFLAGS"] = nil
        ENV["LDFLAGS"] = nil
        system "cmake", "..", "-DCMAKE_TOOLCHAIN_FILE=#{cmake_file}"
        system "make"
      end
      rm_rf "build"
    end
  end
end
