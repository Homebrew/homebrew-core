class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-05.03.07.tar.gz"
  sha256 "d296e5dc4b10d08fbc29e3e0ced7a32abde74ba241bdcd8ba314193877c1e51d"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "88f9b83106b2d7239a3e4335b324f3f2f7426db14950ad85d798fc57af3afdb8"
    sha256 arm64_sonoma:  "17072d149033440ca92ef9f185833b64f322e91243f0747041cb314c9e2ebd7c"
    sha256 arm64_ventura: "9221f338967213041b862ab2f32befa678b0d1e920cf45eb90fa7dac52f73174"
    sha256 sonoma:        "3dce30f94166410f84e74c964e0572b0886fc1622223cc32f03fb753a0db68eb"
    sha256 ventura:       "a9944a7eed2cb1cc66d29056cb545e46c93486017e017a9cdfd80c36983f63d4"
    sha256 arm64_linux:   "f2d6a2f90bccf6a2a3c8da3cc6c7f6f72e40861eb78759f53942e70922914ce8"
    sha256 x86_64_linux:  "9683d158c06c09809e4fad0ae321972d7cb7955d1b9aaa7a0f43114857b6e1ad"
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
