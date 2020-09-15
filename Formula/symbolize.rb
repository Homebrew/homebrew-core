class Symbolize < Formula
  desc "Use this with ex. Dropbox to keep your config files synced between devices"
  homepage "https://github.com/SlimG/symbolize"
  url "https://github.com/SlimG/symbolize/archive/v1.0.tar.gz"
  sha256 "ea8a84745984e806b6dc2d07204ec01fb993aeb56f6fae21985c5900dbb5be37"
  license "Apache-2.0"

  def install
    cp "symbolize", prefix/"symbolize"
    ln_s prefix/"symbolize", HOMEBREW_PREFIX/"bin/symbolize"
  end

  test do
    mkdir(testpath/"config")
    touch(testpath/"testfile")
    system "symbolize", testpath/"testfile", testpath/"config"
    assert_predicate(testpath/"config/testfile", :exist?)
  end
end
