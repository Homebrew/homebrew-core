class Truecrack < Formula
  desc "Brute-force password cracker for TrueCrypt"
  homepage "https://github.com/lvaccaro/truecrack"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/truecrack/truecrack_v35.tar.gz"
  version "3.5"
  sha256 "25bf270fa3bc3591c3d795e5a4b0842f6581f76c0b5d17c0aef260246fe726b3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fb57614e52a889118b43b5ea47d5ae7174ac84525c7496908804d6aca51a8818" => :catalina
    sha256 "8eff51aec7a5413b11d35adcc1559e036687ae31aee11a477cc7d62f603fd1e1" => :mojave
    sha256 "fd148aa52883969c30029e25889c560443347575cb064fe9e93d48e9940afcb6" => :high_sierra
    sha256 "96ecdedf66599ec83da60c5a64de37dce4aa3411bf3a575bb5d5e1b6646fd5b3" => :sierra
    sha256 "2905997955799043b8f07c7cb28854d0a0acd3a84131b92b6c49780570dd198f" => :el_capitan
    sha256 "d7d6879b7132093ebcc716ffe115dc20974c68e7e629f7f7cc3bce5030d153d3" => :yosemite
    sha256 "8357dddf047bdd2180f241edb5848e49a48083300484143a245f41e5def1888d" => :mavericks
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
