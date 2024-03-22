class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.03.03.tar.gz"
  sha256 "fbfbd7e8dbb417ce2665c12777d8c595a54a6c921040e2623ecc6ca4a17e9254"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "e729629ce02319e0f5e3a7a69025875dd8bdbfd8c9181f8a400fecf6344ee88a"
    sha256 arm64_ventura:  "bbc3028e3dcf5120591905b1e18233c0d2cb3997ccbfb1522eabae62b2c5bfc3"
    sha256 arm64_monterey: "b24964e1491035f9a810ac8be1f9e40021643392641c636212052bab28b86774"
    sha256 sonoma:         "3c771af16adbf2a84c1b527edb0ccc19b85805408db4b343d579393c9f7452dc"
    sha256 ventura:        "a9a550f8d86005b09a9da5821d72e0958ebe7ef9571ba218bfa6bc916212ed63"
    sha256 monterey:       "043c572e175abfe0a7be0f9759727284eecaf8e71e04bc49d3474a6f4bb20785"
    sha256 x86_64_linux:   "136b8719f53612364066d6d8d9504fe7a0a791465769004b85efe5dab36ac9a7"
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
