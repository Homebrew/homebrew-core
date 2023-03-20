class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.04.tar.gz"
  sha256 "e8d8ccd9441d94bb277c71efaf35a87ce2025bbed9954107a5c62fd7e47711c3"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "67fcaad3473d70462f08225c0cbc7e608a82b0051f5d50943fa9902b2b59b5c1"
    sha256 arm64_monterey: "ad9ae323b171a4c9ff7c2f978319782ef7d681cd593ee8d2339ee2f71576d05b"
    sha256 arm64_big_sur:  "11751814e48fb1506af7115908528516d48bb1de1ae4e238ac236d8b55ce7862"
    sha256 ventura:        "3f338a5d51958cf6ec97029fac9e4abf24bb81bb17940e172d73f4da09f8ba45"
    sha256 monterey:       "7b38066dd20e1f4fb02a2e70c3368265d361d042e345edcd40e2efe95c010dd8"
    sha256 big_sur:        "d8b60a4406f4993ae212faf2e16cb275790032b41f3a162b7149683e7b5252ed"
    sha256 x86_64_linux:   "1a4082452ff001c22b68bdcefe6e28ef71de3f5ebcb2806cbf0d8d567c6e135a"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
