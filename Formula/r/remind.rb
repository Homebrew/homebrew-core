class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.03.07.tar.gz"
  sha256 "b3f8c4b0d5d406280d1cf4c28b77b8576a4650d84adace7f9feb14d68c3b514d"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "77e0335a23b64b931f1bd3d7e3e578c0772d04e9eac77be0fa73ed4bc8b6d481"
    sha256 arm64_ventura:  "1bece8682228835df9dcc29c90288fe750800b4425d21ca06233e82180838c86"
    sha256 arm64_monterey: "fbf181302173d8d8e379e0b8fb530ce93b12823247098ae5e4e21da36e7ab952"
    sha256 sonoma:         "c8263ed958f77938e313024a0569855a18e4c44cae45ff57bd900715e0c923c9"
    sha256 ventura:        "01d92078191ac29ec5479e6c399d26dc83e21884a72b5fb8e009cc8681489581"
    sha256 monterey:       "453a8296aa51574b649d1703ab3b84642e20550d98aa326f805f2a9b130e2f36"
    sha256 x86_64_linux:   "8b437b1ed29b888572862dc64aabf2a2ea91845fa64e64a498ee353afec55dbe"
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
