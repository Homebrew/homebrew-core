class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://github.com/zmap/zlint"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.6.5.tar.gz"
  sha256 "ce73c3fb8daaad3b4a41473a970e80425d714477d2ef0a6b91829adc1875197b"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29f795e5e0dab8f87d1e796c42cd7b6157ae36b00cc6cfe60e8388c3bcd3e870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f795e5e0dab8f87d1e796c42cd7b6157ae36b00cc6cfe60e8388c3bcd3e870"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29f795e5e0dab8f87d1e796c42cd7b6157ae36b00cc6cfe60e8388c3bcd3e870"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c9a3891731c3a651f571acb39ae62024ebeeabc702a71c458a8a193c1e33403"
    sha256 cellar: :any_skip_relocation, ventura:       "7c9a3891731c3a651f571acb39ae62024ebeeabc702a71c458a8a193c1e33403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bcb5c7126db76b93333ab19ad73b22cb5acb6ed0dc900dbe406586e801bb755"
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
