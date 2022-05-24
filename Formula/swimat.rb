class Swimat < Formula
  desc "Command-line tool to help format Swift code"
  homepage "https://github.com/Jintin/Swimat"
  url "https://github.com/Jintin/Swimat/archive/1.7.0.tar.gz"
  sha256 "ba18b628de8b0a679b9215fb77e313155430fbecd21b15ed5963434223b10046"
  license "MIT"
  head "https://github.com/Jintin/Swimat.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35cb1383fd73f70e1beff4de16dff980252d17116e1234086498046edb6c8cb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5474723b7d13050f04c03a9ba5dc7bf0d962b13ff384f82fd9cf5f47754fdb7a"
    sha256 cellar: :any_skip_relocation, monterey:       "f1c27fb8765ea9c959dea5030c7172c390ccc97f76e2b7f7f47a0e75a5962a92"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4099d895297155fe34b95ff66e214c31fcf2990e03aeaad8e1680061fb580a9"
    sha256 cellar: :any_skip_relocation, catalina:       "6ee6f59882dcec7188ef4684fcada0d22edf68470023fffb73b610f2dbe44112"
    sha256 cellar: :any_skip_relocation, mojave:         "6b9a5174b6050250d0dfe5721102c5455997f2abcef1f2dc6a82686af11117fd"
  end

  depends_on xcode: ["10.2", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-target", "CLI",
               "-configuration", "Release",
               "CODE_SIGN_IDENTITY=",
               "SYMROOT=build"
    bin.install "build/Release/swimat"
  end

  test do
    system "#{bin}/swimat", "-h"
    (testpath/"SwimatTest.swift").write("struct SwimatTest {}")
    system "#{bin}/swimat", "#{testpath}/SwimatTest.swift"
  end
end
