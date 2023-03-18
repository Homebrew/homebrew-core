class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://github.com/zmap/zlint"
  url "https://github.com/zmap/zlint.git",
      tag:      "v3.4.1",
      revision: "84da589869bc2d096b7ae42606bf75c602d88806"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee32cd12404a1470ce1563d47c357e5897c7bcf37b779e7cf6c90e8320cbda01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2108ace81fd6e19f8274eb714a18f81ef80a35522973ccae2e3d1596944bcfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c27508bad3671f435a86d953828ec6a54b931fdb8fc13c9fc1fbb13398b281f"
    sha256 cellar: :any_skip_relocation, ventura:        "a17c789cbbef10d8cf14d2beb19bceecf264d742450229d36aed3f8ebde94065"
    sha256 cellar: :any_skip_relocation, monterey:       "15fc8ad8a2b37b48e996d9b1d18d18d88d3604c1f1515e383c85e4a05fc65808"
    sha256 cellar: :any_skip_relocation, big_sur:        "937dcd7c1cf86a6ac64cf41d2545d3ce4c9b8528cb4791b4dd82918e2ae72b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9904de582fbb438e55e14dc9cc81f31c25048e3fb4a6f8f718aab20e5650e34a"
  end

  depends_on "go" => :build

  def install
    system "make", "--directory=v3", "GIT_VERSION=v#{version}", "zlint"
    bin.install "v3/zlint"
  end

  test do
    assert_match "ZLint version v#{version}",
      shell_output("#{bin}/zlint -version")

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
