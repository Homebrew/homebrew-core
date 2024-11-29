class Rmtrash < Formula
  desc "Move files and directories to the trash"
  homepage "https://github.com/TBXark/rmtrash"
  url "https://github.com/TBXark/rmtrash/archive/refs/tags/0.6.4.tar.gz"
  sha256 "c0918e59dd76104aa37acbc27f514d6f0bc78dec8fdb0b7c782fdeab57c6a743"
  license "MIT"
  head "https://github.com/TBXark/rmtrash.git", branch: "master"

  depends_on xcode: ["12.0", :build]
  depends_on :macos
  uses_from_macos "swift", since: :big_sur

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rmtrash"
  end

  test do
    system bin/"rmtrash", "--help"
  end
end
