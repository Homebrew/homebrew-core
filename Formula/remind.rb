class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.05.tar.gz"
  sha256 "61ed17d86bde93fa7268d57118a2fbef739626f0b823a1799c4b11420cd66ec1"
  license "GPL-2.0-only"
  head "https://dianne.skoll.ca/projects/remind/git/Remind.git"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "17c14cafbf48b0326b70b6492e5d27aceaa14b1642ce766a454d58487ce4448b" => :big_sur
    sha256 "db0687a396b900b0f079101f1b900711da228403b2705f39d13ecfad40a85248" => :arm64_big_sur
    sha256 "7bb46ad0649a5264cd7d9d94122e21a1c7d815cb09ebf7f6d055b80bc15e91f1" => :catalina
    sha256 "2b82a2c8e1223b5563950148a26601e33f06a723e4c7890034499412d5404f50" => :mojave
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
