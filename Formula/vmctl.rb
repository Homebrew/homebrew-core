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
    ldflags = %W[
      -s -w
      -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=vmctl-#{time.strftime("%Y%m%d-%H%M%S")}-#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./app/vmctl"
  end

  test do
    output = shell_output("#{bin}/vmctl vm-native --s \
        --vm-native-src-addr=https://play.victoriametrics.com/select/accounting/1/6a716b0f-38bc-4856-90ce-448fd713e3fe/prometheus \
        --vm-native-dst-addr=https://play.victoriametrics.com/insert/accounting/1/6a716b0f-38bc-4856-90ce-448fd713e3fe/prometheus \
        --vm-native-filter-match='{__name__!=\"\"}' \
        --vm-native-filter-time-start='2023-05-08T11:30:30Z'")
    sleep 90
    assert_match "Requests to make", output
  end
end
