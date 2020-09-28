class WiimmsSzsTools < Formula
  desc "Wiimms SZS Toolset is a set of command-line tools to manipulate Wii files"
  homepage "https://szs.wiimm.de/"
  sha256 "db8b73e41c2bc80e71f6a8fc95513f9a4424800e55dbcfcf1ea4f103b6c61265"
  url "https://download.wiimm.de/source/wiimms-szs-tools/wiimms-szs-tools.source-2.19a.txz"
  license "GPL-2.0-or-later"

  head do
    url "https://github.com/Wiimm/wiimms-szs-tools.git"
  end
  depends_on "libpng" => :build
  uses_from_macos "ncurses"

  def install
    cd "project" do
      system_command "/usr/bin/sed",
                     args: [
                       "-i", ".bak",
                       "-e", "s|INSTALL_PATH=.*|INSTALL_PATH=#{prefix}|g",
                       "setup.sh"
                     ]
      system "make"
      system "/bin/sh", "install.sh", "--no-sudo"
    end
  end

  test do
    system "mkdir", "test_dir"
    system "wszst", "CREATE", "test_dir"
    system "rmdir", "test_dir"
    system "rm", "test_dir.szs"
  end
end
