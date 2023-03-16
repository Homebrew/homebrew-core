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
    sha256 arm64_ventura:  "14769c09e8b30e9a4e69dd02b8d7af31d5bfcf7deb32913647bc3a819534e00b"
    sha256 arm64_monterey: "9c4ce4112a17ec25f12dc738518cce6f34cfe1ef7689365c4301496f564e29dc"
    sha256 arm64_big_sur:  "8266a5df851bb910684a18b90c0f4d2f7ba0a9f6bb890c7f2db8da132474ed19"
    sha256 ventura:        "c768d5cfc2bf8d1af12d1cfe7cd8a834f7192f969243e8745841fd86c004e0df"
    sha256 monterey:       "7240cd78b6a374d7590e3701b5cd8214ef75c713d3e995dc42a07bde0e2a1a36"
    sha256 big_sur:        "ab01fc7fc16dcc92885b840c5937bcb944da1f31728c42a05aba224cc9cc70d8"
    sha256 x86_64_linux:   "9dfa15591599c5c544252c930c3ae89b0d0204b824ecd91338aa1fd7e9947cb1"
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
