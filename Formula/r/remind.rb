class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.02.08.tar.gz"
  sha256 "181b97e6c41b63ba17726f104e5597717ea5af082a411175513059df33d30a15"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "9fdd9aaf029765255c5cae9e0dbb856c1033d90550495c3a6aefd6d41bb5e9d9"
    sha256 arm64_ventura:  "e99c295f24b2ed07cf44fedb8bb8d993f0c36753547fec26aee812636934b112"
    sha256 arm64_monterey: "ee06e7febda09ca3b20d8653d9e3bfe9b786d7b727afb9a76d2f63e9e67fd06b"
    sha256 sonoma:         "993711354daf929953ce71ad0059c8bdef989e113d8b559e44a6326f3fda910a"
    sha256 ventura:        "8968e0a53120a619346e80032d91e80946c4f2dfb2856297a68a23f212fe8244"
    sha256 monterey:       "f37de7be9dec8d27ddf34ee4c300348a3b67673e41287893aa3eff6f352a57c3"
    sha256 x86_64_linux:   "39a2d7ddcb615099917eb6fdc481889424132f65650c4fef8169bf2e9bb8423a"
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
