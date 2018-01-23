class Retry < Formula
  desc "Command retry for the shell"
  homepage "https://github.com/kadwanev/retry/"
  url "https://github.com/kadwanev/retry/releases/download/1.0.0/retry-1.0.0.tar.gz"
  sha256 "c667dd50641adb82b42a6123fb24bf76b9d6ae5f75a02ec9049da7b8ff16401c"

  bottle :unneeded

  def install
    bin.install "retry"
  end

  test do
    system "#{bin}/retry"
  end
end
