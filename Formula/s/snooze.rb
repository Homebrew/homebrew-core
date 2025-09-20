class Snooze < Formula
  desc "Run a command at a particular time"
  homepage "https://github.com/leahneukirchen/snooze"
  url "https://github.com/leahneukirchen/snooze/archive/refs/tags/v0.5.tar.gz"
  sha256 "d63fde85d9333188bed5996baabd833eaa00842ce117443ffbf8719c094be414"
  license :public_domain

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "true"
  end
end
