class Rats < Formula
  desc "Rough auditing tool for security"
  homepage "https://security.web.cern.ch/security/recommendations/en/codetools/rats.shtml"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rough-auditing-tool-for-security/rats-2.4.tgz"
  sha256 "2163ad111070542d941c23b98d3da231f13cf065f50f2e4ca40673996570776a"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "b310ca257b3697a46004e64f9c06bce6ae79bb75c86d832bc74c28cbd1f99a7d"
    sha256 arm64_sequoia:  "0957ff0fe765a50f6ec8a12edc3119741fe39133b438ee114ace6d05288fb06c"
    sha256 arm64_sonoma:   "67a98f4d5385f43dadf88b69c4ea04a4b42a318f9be2820d5c52cb859b69c6e4"
    sha256 arm64_ventura:  "9a47934dabb7a37c3d8a2a0a68a2e25961bfd8fa56be202d4bc604c4850d1cbf"
    sha256 arm64_monterey: "a210be283710fa3c506e9fae4dd915bcd737904272df4c985c5f54d666b3a745"
    sha256 arm64_big_sur:  "bfe1ae23fc4335ffdc160f80613e519c810b259b48ddef7de9d0d227625a3407"
    sha256 sonoma:         "56dea2a14cfbf6893fae49f0913ff57b0468f0a1b8a2bce90fe4aa9ef519b9ab"
    sha256 ventura:        "1599be8be509e96e1310209d4334a0f09ecc2fad0f5f99920af18a4459a67e66"
    sha256 monterey:       "5798bdf316715050aee914343db4155c7ef89fa274908b85def50a84729c0845"
    sha256 big_sur:        "d71b401eb933729bd6d4b8f6cfdae7bbeb7f81de55b91f8d0aadcbb619c1fcce"
    sha256 catalina:       "bf5da3e9088abba09350b4a812691a3f76b00bfce1c74947fb7c016d88eb89f9"
    sha256 arm64_linux:    "9b7cfe5e23808f04987f9f412cfa58d3b86a9223de5801ad9f47415f0c8c783f"
    sha256 x86_64_linux:   "225ac8dd692f21f8f13e072dba7bc2904cb11e08273d9917bde0ef1f42133b03"
  end

  uses_from_macos "expat"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system bin/"rats"
  end
end
