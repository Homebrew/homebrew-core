class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://github.com/zmap/zlint"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "9286b6f153d0a2accac135ae355074963e5afdc55d76d22f0792a76b9898d2e2"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a967b62986a3a7ba2ed12679119628d5cfb6afa722e4411ce50d56264262055"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcf36b08cc7362a43f45885b80f5985e6def4985f00fe7a18bba14faca34ab2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffde7cfe3122f29f824eeb7d5ae7d4bdb693acfbc9303e55134195d5cc021821"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9c4d59a586d3cd889e600be4b6d230a940f6e5da5c7e6df0a5fe53b9f78839b"
    sha256 cellar: :any_skip_relocation, ventura:        "cf2fab738d9836507ba51895f3d2f7e2e59f2fb05a6cd7ab0b1feebd12d93447"
    sha256 cellar: :any_skip_relocation, monterey:       "84941ae9f45a82185fbe18f5e4630f43f6837b47eac77e4ae1e2f850b6d06028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7145a9724424e2a33b326b7b174c898d56632d8c897cd18cbf5e8f540eea117"
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
