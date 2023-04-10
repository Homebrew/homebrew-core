class Vmctl < Formula
  desc "Data migration tool used to migrate data from supported DBs to VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/vmctl.html"
  url "https://github.com/VictoriaMetrics/VictoriaMetrics.git",
      tag:      "v1.90.0",
      revision: "b5d18c0d281b5bcd4dc13cc72d897c38fd4bb374"
  license "Apache-2.0"
  head "https://github.com/VictoriaMetrics/VictoriaMetrics.git", branch: "master"

  depends_on "go" => :build

  def install
    system "make", "vmctl"
    bin.install "bin/vmctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vmctl --version")
  end
end
