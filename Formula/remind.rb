class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://www.roaringpenguin.com/products/remind"
  url "https://www.roaringpenguin.com/files/download/remind-03.01.15.tar.gz"
  sha256 "8adab4c0b30a556c34223094c5c74779164d5f3b8be66b8039f44b577e678ec1"

  bottle do
    cellar :any_skip_relocation
    sha256 "eec9be8332d946fd16913b846d163b74a1547b44682852e943c9d4af7597c726" => :mojave
    sha256 "c0d65b1c0428721038f25d11e4ad00de344b34bca29e23afa5354e4efcfbd955" => :high_sierra
    sha256 "b89632422362efd9660eb98e53dfe3ca62006003c34a03d3b57bb8698b3a53a1" => :sierra
    sha256 "c720948c84996b651176968c096492da2242cb6b57226e04e25f9251c782491a" => :el_capitan
    sha256 "b72ffda6998a1c203686b82b8e07c3132bc380fb9126a2ca22254608d3c418c8" => :yosemite
    sha256 "958eafdd458799e788457837d01ef387c5368ffee6f9a6b1ce363678a9cbc8a5" => :mavericks
    sha256 "fb78fa7e3df893822473b56d79d64d48ff5827c7df3ce6d518985262c99d3056" => :mountain_lion
  end

  conflicts_with "rem", :because => "both install `rem` binaries"

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub! /rkrphgvba\(.\);/, ""
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    reminders = "reminders"
    (testpath/reminders).write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n", shell_output("#{bin}/remind #{reminders} 2015-01-01")
  end
end
