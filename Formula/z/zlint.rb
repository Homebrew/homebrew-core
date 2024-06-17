class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://github.com/zmap/zlint"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "6181f735e713b59242ecda493f9377a0873023ba70d2566a4cba453c05edb2a2"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f96df6787d7e778917724b21842370ebd7f99c9b62827ca5d5e0d4ec8c2c1374"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38e8a59aeb955f9cf95ae0c7527acea0759a23e0ececcacf146ef5ad0921c51d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3571eb8af6c8ec828f923e0445648aa15fed3480063936a56125cdc2fa873931"
    sha256 cellar: :any_skip_relocation, sonoma:         "cdfd730af4703fbd3e3f9c99b897107c7e2efb788d2af8d77cde35bd9277d76b"
    sha256 cellar: :any_skip_relocation, ventura:        "7157e453e8d89ddc0ed9b09984c4e171ca4d8da12a0aad016de3a68da092d986"
    sha256 cellar: :any_skip_relocation, monterey:       "5f18c53d51cfede19e88d598d615b331ec9b4bbcadfa6377a8cc73d04abd146b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa5d22b5070fa855ba2cd902576e4584020994e83da6da093056441db05a5337"
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
