class Range2ip < Formula
  desc "Converts IP ranges to individual IPs"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/range2ip-1.0.0.tar.gz"
  sha256 "589d93e79892da6a260ad37a3f760785b13401dc495ebc85bab765fa857ddac5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^range2ip[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./range2ip"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/range2ip --version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3", shell_output("#{bin}/range2ip 1.1.1.0-1.1.1.3").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3", shell_output("#{bin}/range2ip 1.1.1.0,1.1.1.3").chomp
    assert_equal "1.1.1.3\n1.1.1.2\n1.1.1.1\n1.1.1.0", shell_output("#{bin}/range2ip 1.1.1.3-1.1.1.0").chomp
    assert_equal "1.1.1.3\n1.1.1.2\n1.1.1.1\n1.1.1.0", shell_output("#{bin}/range2ip 1.1.1.3,1.1.1.0").chomp
  end
end
