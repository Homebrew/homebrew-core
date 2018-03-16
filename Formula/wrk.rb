class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.1.0.tar.gz"
  sha256 "6fa1020494de8c337913fd139d7aa1acb9a020de6f7eb9190753aa4b1e74271e"
  head "https://github.com/wg/wrk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8167375044c6ff20f33e2d94f92fe2977bb25f19f561f1d5f2eb241b0feda62c" => :high_sierra
    sha256 "1ace345f489c0fc589b619e96a748bf841ff9134a70016b76cde5ae06795369f" => :sierra
    sha256 "23f7c0c7b86691a810238679dee61662781a70b13db95c6dfee4d469845867c1" => :el_capitan
  end

  depends_on "openssl"

  conflicts_with "wrk-trello", :because => "both install `wrk` binaries"

  def install
    ENV.deparallelize
    system "make"
    bin.install "wrk"
  end

  test do
    system "#{bin}/wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end
