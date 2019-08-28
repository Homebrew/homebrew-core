class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.1.0.tar.gz"
  sha256 "6fa1020494de8c337913fd139d7aa1acb9a020de6f7eb9190753aa4b1e74271e"
  head "https://github.com/wg/wrk.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bf22b23f21ae787e2a114f0138519710f5f1e3069ba7480c5c1c0217cac62873" => :mojave
    sha256 "1366e8330c9013002d43984b4a80dfc16e73fa23b91b72eb0c8ee2df512628e1" => :high_sierra
    sha256 "8aece2b0e05cfce8f9e1bc408bc043c8340e999cb175c2396ec94d9a8ead2221" => :sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "wrk-trello", :because => "both install `wrk` binaries"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    system "make"
    bin.install "wrk"
  end

  test do
    system "#{bin}/wrk", "-c", "1", "-t", "1", "-d", "1", "https://example.com/"
  end
end
