class Repeat < Formula
  desc "Execute the given command repeatedly"
  homepage "https://www.netmeister.org/apps/repeat.html"
  url "https://www.netmeister.org/apps/repeat-1.0.tar.gz"
  sha256 "bc1a88e455cbb31270bd951be7db82ceb7b7469193740b34824849fd4f9e673b"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.netmeister.org/apps/"
    regex(/href=.*?repeat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "repeat", "-n", "2", "-J", "%", "/bin/sh", "-c", "touch %"
    assert_predicate testpath/"1", :exist?
    assert_predicate testpath/"2", :exist?
  end
end
