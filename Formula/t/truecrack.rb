class Truecrack < Formula
  desc "Brute-force password cracker for TrueCrypt"
  homepage "https://github.com/lvaccaro/truecrack"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/truecrack/truecrack_v35.tar.gz"
  version "3.5"
  sha256 "25bf270fa3bc3591c3d795e5a4b0842f6581f76c0b5d17c0aef260246fe726b3"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fa006f2b40a1844949c625ee3ded3b0626420c1969b7595b5081ba471a8ce234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f14ab900548cbe7d0b0f713604d6d63a7c41874e9d73d36f9aa0ff36ab58af33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c14111bcb0920f73fa1af5ed3daed97cb19152ea38aa9583a75c5c9a05b47d81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dec2443fbc84baf2fddd59c65666390b490b3156354fe092eaa4440e3732c078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "255979daec38fcb5b7af34d55a34bf54f71c9ad5935117eb5b5dc2685022aa71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d16243315d1cff0bc8f1341cfdc31d9385d0c411fba462cdfa00b81326245b79"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cf756cf417d9ae2be44f0d27e56b2ed785524df77cdbae2ff8f05e50805bdab"
    sha256 cellar: :any_skip_relocation, ventura:        "7ec74e37f62c3e23612137ed389121530914e6b3d5ac38d62738e3dcbfa0ac09"
    sha256 cellar: :any_skip_relocation, monterey:       "b776b06cdbe28835e7899c72a5cc5a54438d052b7b147163edc6adc710c80022"
    sha256 cellar: :any_skip_relocation, big_sur:        "101def9295ec59ebe5391aefe7384944aecc52e6cc610edddbb4cb0fcaad489d"
    sha256 cellar: :any_skip_relocation, catalina:       "fb57614e52a889118b43b5ea47d5ae7174ac84525c7496908804d6aca51a8818"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fd2c903e910b747ac43ee9604851ea08131dbda84ed405b43f51110b3c29037a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ed8fdfc8e7a6289dd469d0dbc4bac91f00d8917d3609e5b2ac44d1d641fb86"
  end

  # Fix missing return value compilation issue
  # https://github.com/lvaccaro/truecrack/issues/41
  patch do
    url "https://gist.githubusercontent.com/anonymous/b912a1ede06eb1e8eb38/raw/1394a8a6bedb7caae8ee034f512f76a99fe55976/truecrack-return-value-fix.patch"
    sha256 "8aa608054f9b822a1fb7294a5087410f347ba632bbd4b46002aada76c289ed77"
  end

  def install
    if OS.linux?
      # Issue ref: https://github.com/lvaccaro/truecrack/issues/56
      inreplace "src/Makefile.in", /^CFLAGS = /, "\\0-fcommon -Wno-implicit-function-declaration "
    elsif DevelopmentTools.clang_build_version >= 1403
      # Fix compile with newer Clang
      inreplace "src/Makefile.in", /^CFLAGS = /, "\\0-Wno-implicit-function-declaration "
    end

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    # Re datarootdir override: Dumps two files in top-level share
    # (autogen.sh and cudalt.py) which could cause conflict elsewhere.
    system "./configure", "--enable-cpu",
                          "--datarootdir=#{pkgshare}",
                          "--mandir=#{man}",
                          *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"truecrack"
  end
end
