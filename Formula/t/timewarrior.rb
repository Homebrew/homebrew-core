class Timewarrior < Formula
  desc "Command-line time tracking application"
  homepage "https://timewarrior.net/"
  url "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.9.1/timew-1.9.1.tar.gz"
  sha256 "7ad34f95c0d61d356df55149f9479f8d9aaec417e5f57f2a1cc76ae2f8a3171b"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/timewarrior.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea4c97b2d577a0a3d268ec4a2ca79244775d73718203df09e5b23523061f74f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83db5313c87e12f701f786f9149982b3d38ecf2dc1813ef1a22b91e07902ba16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6260c851ad3262bcc6c1016c5f742129207079ae5a17d75d33df1dff11bf0922"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40fe36d1b5f38ecf7fe8c8161cace77be60a7165a13cf44e68e82eecdbb64017"
    sha256 cellar: :any_skip_relocation, sonoma:        "d40e37d723c4aee31fca85d467c047464b1397f97ae948efbff46d3e1a56df2d"
    sha256 cellar: :any_skip_relocation, ventura:       "f4cdb02ac055a05689acb45862cb6bb3af49d2bfe7aaa3f81353b54d09ebe932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "110987680619bdb5ca21d536a4a63d5e6fb645dffdd3a77b86f0394349e50d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ec84c5fd5f38ff35f9dfb8d893dec579c8ddf79864b79dafb38714e0f05f46"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build

  on_linux do
    depends_on "man-db" => :test
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".timewarrior/data").mkpath
    (testpath/".timewarrior/extensions").mkpath
    touch testpath/".timewarrior/timewarrior.cfg"

    man = OS.mac? ? "man" : "gman"
    system man, "-P", "cat", "timew-summary"

    assert_match "Tracking foo", shell_output("#{bin}/timew start foo")
  end
end
