class Sshs < Formula
  desc "Graphical command-line client for SSH"
  homepage "https://github.com/quantumsheep/sshs"
  url "https://github.com/quantumsheep/sshs/archive/refs/tags/1.3.1.tar.gz"
  sha256 "cc6cdfe6be6f3efea29c8acc5a60ea037a88e445bced1619e7002a851d9bbe88"
  license "MIT"

  depends_on "go" => :build
  depends_on "make" => :build

  def install
    system "make", "build", "VERSION=#{version}", "OUTPUT=#{bin}/sshs"
  end

  test do
    assert_equal "sshs version #{version}", shell_output("#{bin}/sshs --version").strip
  end
end
