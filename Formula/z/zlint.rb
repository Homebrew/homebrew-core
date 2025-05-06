class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://zmap.io/"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.6.6.tar.gz"
  sha256 "ca1155915d68772566d8be4c4061129b15eb7055ea9aaa939cc92d3966ba10f6"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3edaff6afb2185ddc9e3a25da2ae19e88e386f010a57ea13c8cbdd4976cb4ac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3edaff6afb2185ddc9e3a25da2ae19e88e386f010a57ea13c8cbdd4976cb4ac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3edaff6afb2185ddc9e3a25da2ae19e88e386f010a57ea13c8cbdd4976cb4ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "812f893df4a2cce77a54df0cf2d536c7193bb88399379d3d5354415760bb6394"
    sha256 cellar: :any_skip_relocation, ventura:       "812f893df4a2cce77a54df0cf2d536c7193bb88399379d3d5354415760bb6394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558268e135da92e62fc493c7a2a46a7fb93f1c7d499d310c96939d2cd18d8d24"
  end

  depends_on "go" => :build

  def install
    cd "v3" do
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", *std_go_args(ldflags:), "./cmd/zlint"
    end
  end

  test do
    assert_match "ZLint version #{version}", shell_output("#{bin}/zlint -version")

    (testpath/"cert.pem").write <<~PEM
      -----BEGIN CERTIFICATE-----
      MIIB3jCCAWSgAwIBAgIUU3hxzxSDV5V1DeRyZjgzdPKatBEwCgYIKoZIzj0EAwMw
      HjEcMBoGA1UEAwwTaG9tZWJyZXctemxpbnQtdGVzdDAeFw0yMjAxMDEwMDAwMDBa
      Fw0yMzAxMDEwMDAwMDBaMB4xHDAaBgNVBAMME2hvbWVicmV3LXpsaW50LXRlc3Qw
      djAQBgcqhkjOPQIBBgUrgQQAIgNiAASn3DDorzrDQiWnnXv0uS722si9zx1HK6Va
      CXQpHm/8t1SmMEYdVIU4j5UzbVKpoMIkk9twC3AiDUVZwdBNL2rqO8smZiKOh0Tz
      BnRf8OBu55C7fsCHRayljjW0IpyZCjCjYzBhMB0GA1UdDgQWBBRIDxULqVXg4e4Z
      +3QzKRG4UpfiFjAfBgNVHSMEGDAWgBRIDxULqVXg4e4Z+3QzKRG4UpfiFjAPBgNV
      HRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAKBggqhkjOPQQDAwNoADBlAjBO
      c1zwDbnya5VkmlROFco5TpcZM7w1L4eRFdJ/q7rZF5udqVuy4vtu0dJaazwiMusC
      MQDEMciPyBdrKwnJilT2kVwIMdMmxAjcmV048Ai0CImT5iRERKdBa7QeydMcJo3Z
      7zs=
      -----END CERTIFICATE-----
    PEM

    output = shell_output("#{bin}/zlint -longSummary cert.pem")
    %w[
      e_ca_organization_name_missing
      e_ca_country_name_missing
    ].each do |err|
      assert_match err, output
    end
  end
end
