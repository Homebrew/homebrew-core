class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.04.tar.gz"
  sha256 "d633058cc6fd445de1092943816879a4add16fef7b3eaa668c29819cc32170e4"
  license "GPL-2.0-only"
  head "https://dianne.skoll.ca/projects/remind/git/Remind.git"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f4c4d7cad039e7eab881a6ed2f2b5b66cb721a3de2af4375a7f1102739cbae02" => :big_sur
    sha256 "389f6a3b60d0023d7dafcf01b3281591b94bb6b6bab7a4610ed63c37f9e86038" => :arm64_big_sur
    sha256 "f8e8700c70324229b72d14ab1a391909036c912dc04a7b5a74d461f3f2d4393c" => :catalina
    sha256 "e5ab4837656fed7e9f5649a6fb170a3d990aeeff1b05fa7b152eb128e3a939c0" => :mojave
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub! /rkrphgvba\(.\);/, ""
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
