class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-06.03.00.tar.gz"
  sha256 "5d7b8f9b80944abfd431c153cdb64b857d034bf7915eefee7a3e2dbb6e12260f"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "fc2c240bf9f3d2fa8c054ad6bc46b7531e912c85dd1cbf2979875fb36b4e9c8a"
    sha256 arm64_sequoia: "00c2cb8989aad95e2acbb552fc98bb8c58161861ade770fe1cf613468c453c2f"
    sha256 arm64_sonoma:  "8e96ded035a068ab54b1c43faa84b46ceff89305458a8aca84366c80cff52984"
    sha256 sonoma:        "d1851208705a2c0b49fad6691af774ab865cc32e44f148ae2428735f42bfad55"
    sha256 arm64_linux:   "d48e9d26431ea68c8c1e6ed1894bfa69d836e13998bc20ce21584b59b9d6a1a7"
    sha256 x86_64_linux:  "53087f2ce312b0641ebd4af3668f6f189e3520cecc6d29a3c7160af647fc2cad"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Fix to error: unsupported option '-ffat-lto-objects' for target 'arm64-apple-darwin24.4.0'
    inreplace "configure", "-ffat-lto-objects", "" if DevelopmentTools.clang_build_version >= 1700

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders.rem").write <<~REM
      SET $OnceFile "./once.timestamp"
      REM ONCE 2015-01-01 MSG Homebrew Test
    REM
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders.rem 2015-01-01")
  end
end
