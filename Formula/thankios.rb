class Thankios < Formula
  desc "Acknowlegements Settings.bundle generator for CocoaPods and Carthage."
  homepage "https://github.com/uny/Thankios"
  url "https://github.com/uny/Thankios/archive/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "e9aed4c539d6e93cbe16f58017bde4102c43b20dd6d5b9599e4bb15a237d6d40"

  depends_on :xcode => ["7.2", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/thankios"
  end
end
