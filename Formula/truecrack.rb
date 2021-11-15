class Truecrack < Formula
  desc "Brute-force password cracker for TrueCrypt"
  homepage "https://github.com/lvaccaro/truecrack"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/truecrack/truecrack_v35.tar.gz"
  version "3.5"
  sha256 "25bf270fa3bc3591c3d795e5a4b0842f6581f76c0b5d17c0aef260246fe726b3"
  license "GPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "255979daec38fcb5b7af34d55a34bf54f71c9ad5935117eb5b5dc2685022aa71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d16243315d1cff0bc8f1341cfdc31d9385d0c411fba462cdfa00b81326245b79"
    sha256 cellar: :any_skip_relocation, monterey:       "b776b06cdbe28835e7899c72a5cc5a54438d052b7b147163edc6adc710c80022"
    sha256 cellar: :any_skip_relocation, big_sur:        "101def9295ec59ebe5391aefe7384944aecc52e6cc610edddbb4cb0fcaad489d"
    sha256 cellar: :any_skip_relocation, catalina:       "fb57614e52a889118b43b5ea47d5ae7174ac84525c7496908804d6aca51a8818"
    sha256 cellar: :any_skip_relocation, mojave:         "8eff51aec7a5413b11d35adcc1559e036687ae31aee11a477cc7d62f603fd1e1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fd148aa52883969c30029e25889c560443347575cb064fe9e93d48e9940afcb6"
    sha256 cellar: :any_skip_relocation, sierra:         "96ecdedf66599ec83da60c5a64de37dce4aa3411bf3a575bb5d5e1b6646fd5b3"
    sha256 cellar: :any_skip_relocation, el_capitan:     "2905997955799043b8f07c7cb28854d0a0acd3a84131b92b6c49780570dd198f"
    sha256 cellar: :any_skip_relocation, yosemite:       "d7d6879b7132093ebcc716ffe115dc20974c68e7e629f7f7cc3bce5030d153d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13ed8fdfc8e7a6289dd469d0dbc4bac91f00d8917d3609e5b2ac44d1d641fb86"
  end

  # Fix missing return value compilation issue
  # https://github.com/lvaccaro/truecrack/issues/41
  patch do
    url "https://gist.githubusercontent.com/anonymous/b912a1ede06eb1e8eb38/raw/1394a8a6bedb7caae8ee034f512f76a99fe55976/truecrack-return-value-fix.patch"
    sha256 "8aa608054f9b822a1fb7294a5087410f347ba632bbd4b46002aada76c289ed77"
  end

  def install
    # Re datarootdir override: Dumps two files in top-level share
    # (autogen.sh and cudalt.py) which could cause conflict elsewhere.
    system "./configure", "--enable-cpu",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/truecrack"
  end
end
