class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.01.tar.gz"
  sha256 "d1a164d1c2d1e963d5f1f251457a8065cae12f36e3914cac1e54275180499478"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb1470b7207336fee89f03b6a7d540ff21720ec27f3a18abb0c938a815efca05" => :catalina
    sha256 "09c627b85760732ba5a9e52e184458e1ea6be7b69d35cad34fe1c0e2d6189d4c" => :mojave
    sha256 "2c99a0b697e0b93cd8d43c39fd81f4c220c280ee2c260e573c39ff2f749e01b6" => :high_sierra
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
