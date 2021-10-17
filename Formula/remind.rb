class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.09.tar.gz"
  sha256 "c9087a8c691136442f3e882e46677ad36e69084b2f3bbc3c5b760d3b6bf3b6f3"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "afca5089ee626813ac35ada41686bf93a3bbd91a816e74c08f8f541e683e8b3c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e89d4e7bbb52603fa5d3685024e6d224058323ddebb3e45ced59aff454758f8c"
    sha256 cellar: :any_skip_relocation, catalina:      "5a4f3ee32e49c6190d4801b2946926a233f473bd25a78f495781ac24213c6d3c"
    sha256 cellar: :any_skip_relocation, mojave:        "0f79a1688aa275201660ad40b624ba5bd10cd857d021779a182dfb1ea81b89b8"
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
