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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "592f24616aae6cee0812a1f5c49b24ae2e4b2640ce33a4c2b517fd1dc4cd76a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23316bd202a1d1e14eaa0d65457e9aa67381f978ecef569c6168f25d6f9bff87"
    sha256 cellar: :any_skip_relocation, monterey:       "4db520068c6875b6374729ec7b8e0e174aca4e4c183621fbc8c2f8eb982170df"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4ac21abe4902371e78e3535f474f75b9226a26d41a6b0d2c76fcb60d7cf7e17"
    sha256 cellar: :any_skip_relocation, catalina:       "dd07a739df85b3fc68f68a74b5ac2b441dbb79adc9f8be4157bcb18ce9f93392"
    sha256 cellar: :any_skip_relocation, mojave:         "25d7f636960dd34264dfc3f35f5b79105eeff5512cf9b84b274f02203af7d0ca"
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
