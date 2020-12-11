class Rmtrash < Formula
  desc "Command rmtrash moves directory entries to Trash on macOS"
  homepage "https://changkun.de/s/rmtrash"
  url "https://github.com/changkun/rmtrash/archive/v0.0.1.tar.gz"
  sha256 "49f8034f334f46b1b5c9acbc177b43fe669036da7b1ce516faa8866aa57b9c39"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/rmtrash"
  end

  test do
    system "#{bin}/rmtrash", "-v"
  end
end
