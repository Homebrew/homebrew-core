class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.12.tar.gz"
  sha256 "d4aa4cda5a1b53e2acc631e935e031c00c77982ad4f0867286f7d8270954409e"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02724b3f2076efdd868bea95169b6312b4ea63a63f8f55f26506eca78e0c0862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebe9a6e292d2a734f424efd070d95e96b839bf403fa7aa3661de5bd8b41021db"
    sha256 cellar: :any_skip_relocation, monterey:       "fb3de5a6284795af94d6e93a3433571970b13b036c97ec92cdb3a882a53a3f94"
    sha256 cellar: :any_skip_relocation, big_sur:        "63c64b92dbcb163827f92093b1f90621ae4f767454a12f94f83a307392d3207c"
    sha256 cellar: :any_skip_relocation, catalina:       "4334ea14d8923b7387fb04a05ff0b74ec6b0d0468a37fa0bda8d83d59b0e0157"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub!(/rkrphgvba\(.\);/, "")
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
