class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.00.tar.gz"
  sha256 "96895b981ae59c3ba136c59ad54bccaa4fb959197f371aff4eb16eca81b3b61a"

  bottle do
    cellar :any_skip_relocation
    sha256 "243175a204fbd75f2be9308ccd786bf8fd19fbbea8a9a61b9d5e9f0b83fdbd53" => :catalina
    sha256 "713f7bdcc7216e2af7debec1ca21bac61b3f2adccae92c93d16a995a127d77c1" => :mojave
    sha256 "3196bf41eed1e1bade70a68eb536f60d521144f52b9d28e3cbef821cddae5de3" => :high_sierra
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
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
