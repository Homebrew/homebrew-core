class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://zmap.io/"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "43509828d64135a47b7cc25e7e45acfa01abcc787669ec2bd86cc423fc822c6b"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "673cc12af5343ae9cc3dd28bb37ba5d0a5c9c463ede07a22ef6fbed225dc8f9d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "673cc12af5343ae9cc3dd28bb37ba5d0a5c9c463ede07a22ef6fbed225dc8f9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "673cc12af5343ae9cc3dd28bb37ba5d0a5c9c463ede07a22ef6fbed225dc8f9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "95d04b39ac2ca569a6850af121925c87b74f818a9a7648619a70a4cf5a4cb0e3"
    sha256 cellar: :any,                 x86_64_linux:      "db085c7c464408a35934f6412460358952bc7933ce8da39b4f1b194eee03b898"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "v3"
  end

  def install
    system "go", "build", "-C", "v3", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zlint"
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
