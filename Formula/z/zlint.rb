class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://zmap.io/"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.6.8.tar.gz"
  sha256 "9d977980e69aedde7deb93417e75bba44fa8ebee421ffbc7c9f949a827e8f55e"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b781117436a005df46e97e231b46343698cb213b713e39fa8ff43c30420fed2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b781117436a005df46e97e231b46343698cb213b713e39fa8ff43c30420fed2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b781117436a005df46e97e231b46343698cb213b713e39fa8ff43c30420fed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "962ca2709da99e3ba3bd1ff33e7ebc0e2b10480777dd6ace31e84d8557f2b41a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c132f7afb529f7a67e67826d078fb2320a6d72d53ba60691c4f4defc09106e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c31014388fd3bfbb30ecfc594d06912c04b41ae88b68249715d3c4aabd7523a"
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
