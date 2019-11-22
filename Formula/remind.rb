class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.01.17.tar.gz"
  sha256 "c955c196ffd368720fc4af91823f88d66a47be8d28736f279918ab64a460fe51"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d1c2871766946e5341f0103b2880e887e5fe62612d8108ad45856a161434e42" => :catalina
    sha256 "3e980511c004eb678cc24e9fa083501b470e7dd87dfee99cd4bf483a0de8ec2f" => :mojave
    sha256 "f9c4efc40e72ee9b6b07cea755de607df275ab9fbb183620410e4f4e347af647" => :high_sierra
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
