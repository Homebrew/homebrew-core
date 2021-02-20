class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/v1.1.0.tar.gz"
  sha256 "0a102c863f60402ab48908563edde38450add0ae02454360fa94065824a61907"
  license "Apache-2.0"

  bottle :unneeded

  def install
    bin.install "public/bin/shellshare"
  end

  test do
    system "#{bin}/shellshare", "-v"
  end
end
