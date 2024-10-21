class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://github.com/zmap/zlint"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "548562c1a7470c6d1c602a077c4e0cb5718ccb53a6e16e49e0671ea8337dae45"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c86370f3ad070d0f3c848347100a48bd31ee400aa0225e31029fa51b73e93055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c86370f3ad070d0f3c848347100a48bd31ee400aa0225e31029fa51b73e93055"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c86370f3ad070d0f3c848347100a48bd31ee400aa0225e31029fa51b73e93055"
    sha256 cellar: :any_skip_relocation, sonoma:        "0febef86ad445d8aeb0c89144a357e94134971bf0d61d8d0ca6394a4a0b831d8"
    sha256 cellar: :any_skip_relocation, ventura:       "0febef86ad445d8aeb0c89144a357e94134971bf0d61d8d0ca6394a4a0b831d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf6bd14ba1a065b0c51325fef84fb1a7d382cbccb6bca6913e83860a650680e"
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

    (testpath/"cert.pem").write <<~EOS
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
    EOS

    output = shell_output("#{bin}/zlint -longSummary cert.pem")
    %w[
      e_ca_organization_name_missing
      e_ca_country_name_missing
    ].each do |err|
      assert_match err, output
    end
  end
end
