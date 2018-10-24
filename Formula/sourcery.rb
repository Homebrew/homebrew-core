class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/0.15.0.tar.gz"
  sha256 "b695713996fff2de8390fae42b81686eac85f1603554cc202edbbd8693f8a32e"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce8ce8fb0ca123c1438af064028e2ded3f471493df7df59a9df17f203e97aaa0" => :mojave
    sha256 "1fbb13334d2301366fc46c324e2826dad4b14044b79480962bb7ed46ad126a40" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
