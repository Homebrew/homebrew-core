class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.02.00.tar.gz"
  sha256 "a52dbb033cb47a365689f0d03682ce11eff9c408f575cf69b17b763af4841204"

  bottle do
    cellar :any_skip_relocation
    sha256 "e020d939de67a30ea416682bfcc22e0c0202f87696dbd98d234bbbc686ec69a6" => :catalina
    sha256 "cbf0c4fe2faa65b2bba5bd2756d959911d6edc1b95ad0c5dcd7e4fabbc00c870" => :mojave
    sha256 "6724e071cc10ef3616ae5e076f4b9dd3582ad6fba1bfdb77d5e984bde12a15ed" => :high_sierra
  end

  conflicts_with "rem", :because => "both install `rem` binaries"

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
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n", shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
