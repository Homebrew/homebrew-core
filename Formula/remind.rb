class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.03.07.tar.gz"
  sha256 "87c94e29d1e18954ff5d22247d7eca307ce621e11d22c14208f903f68a3b8a3d"
  license "GPL-2.0-only"
  head "https://dianne.skoll.ca/projects/remind/git/Remind.git"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8889b0d310444a0dc0172e7f13d50685e0e31bca7e972d52c0201871f3ba8203"
    sha256 cellar: :any_skip_relocation, big_sur:       "c01cb172254512e7d7b917dd8a99c91fdd73ddd67a09eab9742f318a39fa3c76"
    sha256 cellar: :any_skip_relocation, catalina:      "bf974275e590f8499d3a1083eb2f4ee65adad59d53d3a6106dc856775fee62c7"
    sha256 cellar: :any_skip_relocation, mojave:        "e7504ca7732c99321a678add4d98f20efc38e9a503bcb207ab575ad514156ab2"
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
