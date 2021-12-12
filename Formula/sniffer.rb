class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/v0.5.1.tar.gz"
  sha256 "6517f4edf3f655963c3ff7f57a7f8c472bf8d2f4638f86d1ae06aef8a3e72e15"
  license "MIT"
  
  depends_on "go" => :build
  
  uses_from_macos "libpcap"
  
  def install
    system "go", "build", *std_go_args
  end
  
  test do
    system bin/"sniffer", "-l"
  end
end
