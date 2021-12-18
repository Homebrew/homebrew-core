class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/v0.5.1.tar.gz"
  sha256 "b9fbead3f72e31a6599e0dffa6e5f7e09b9a68baf6de69b7313f568988e93c6b"
  license "MIT"

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "lo", shell_output("#{bin}/sniffer -l")
  end
end
