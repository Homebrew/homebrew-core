class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://zmap.io/"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.6.7.tar.gz"
  sha256 "3d7c1cc380369c73361a4c6b75e7e880daaad23efcc0107656f0f011168e07d3"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84fb1192e8e57003a40ef3c1b24f4d1152591a624624b58e0c31ae840aac1313"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01d88f23a941d2686472a302179cb5ffeb2d5639f798a3119f3c4c6fd5cf952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d01d88f23a941d2686472a302179cb5ffeb2d5639f798a3119f3c4c6fd5cf952"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d01d88f23a941d2686472a302179cb5ffeb2d5639f798a3119f3c4c6fd5cf952"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5b4896284fec310bfd283b871e789b37cf9d49fd76ac39c4c8b70c4d2df7e1e"
    sha256 cellar: :any_skip_relocation, ventura:       "a5b4896284fec310bfd283b871e789b37cf9d49fd76ac39c4c8b70c4d2df7e1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77bc3761ab0027e95068865a162c56ff611e6292099940073ce1ae99c75b8c51"
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
