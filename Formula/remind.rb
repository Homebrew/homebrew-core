class Remind < Formula
  desc "Sophisticated calendar and alarm"
  homepage "https://dianne.skoll.ca/projects/remind/"
  url "https://dianne.skoll.ca/projects/remind/download/remind-03.04.00.tar.gz"
  sha256 "b88a48ca0c55e65d76d8537cb33f8e31e421f222f8572f3b10cd7f0a316f2d52"
  license "GPL-2.0-only"
  head "https://git.skoll.ca/Skollsoft-Public/Remind.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?/download/remind-(\d+(?:[._]\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6bc38a9340f48278b1a8753566f338379f3889b1ba45f632fc5dc80bd5c0e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d30e36523053c01dce20c8090ffd04774d93cdc912fa963c3f73fe228f81e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "5cdbb26b9750ad704d8224c17a3387f03fd711aa80b75563792bdcee29a68b42"
    sha256 cellar: :any_skip_relocation, big_sur:        "016e021500b05d5ad420f54564125be50807d3ca9764c7a02260f5ca05a0baee"
    sha256 cellar: :any_skip_relocation, catalina:       "5ed2f039bc0730edf9de3b416b4df24ab4c5ce0e919c8b5c2c8cb9a019340733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee7764c920542b2d990f5d8eb44dd0cc3a3bb042ef6aba084d826d9f1ae503d"
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
