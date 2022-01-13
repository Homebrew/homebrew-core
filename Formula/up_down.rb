class UpDown < Formula
  desc "A simple console game, implemented in C++"
  homepage "https://github.com/nltb99/up_down"
  url "https://github.com/nltb99/up_down/releases/download/v0.1.0/up_down.tar.gz"
  sha256 "022e4f3b59a24847a732cf2b733ee463e743fcd216c4e2567246aa22fff988cd"
  license ""

  def install
	bin.install "up_down"
  end

  test do
    system "false"
  end
end
