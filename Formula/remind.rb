class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-04.00.01.tar.gz"
  sha256 "3615d2ed6a456cab911620160d2cbe83d3e861541ca6e80ba6940417f4b959e2"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "a690ac54133cb7bce12080a0dc9217bc547e354b562f782c18033294991add86"
    sha256 arm64_big_sur:  "a743d76c2759052884e56943346b3583dc1d7c0d2476ed04f945f6c60feacfd1"
    sha256 monterey:       "c85cd7481d6ecebb52b75bc621a754212d08bcb80d00343293876c1d785d9d16"
    sha256 big_sur:        "24c1e6191f059785a65160c2e8308dc89a05f64264a1a5c50445a60ad05a2460"
    sha256 catalina:       "f843dd7fd0414a6265ddbca478dc873bc950665f945e6e3f10e59620503aa5dc"
    sha256 x86_64_linux:   "0c199d684dbc3238cc59ab87ad25a2f0977f72eadb9382f409175a9ebc810c9e"
  end

  conflicts_with "rem", because: "both install `rem` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"reminders").write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n",
      shell_output("#{bin}/remind reminders 2015-01-01")
  end
end
