class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://zmap.io/"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "b90aa52e3a2ade269783209982c644a834cda509cbc51f3ad91bddfae66519c9"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22919c9a29772eead8fffb5028d346a8ce755083e398fb08079d8dbd78a26d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22919c9a29772eead8fffb5028d346a8ce755083e398fb08079d8dbd78a26d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22919c9a29772eead8fffb5028d346a8ce755083e398fb08079d8dbd78a26d2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "82d307c4768a18120a1c9bef27b72b2d451d2740866a2d815f368b3a65532e6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fed9751aca8b2a99f88eeb4d96afbf9404d994dd351c232a73c637a7445fc663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9259c2aa524ed1a44f286fe3777bdce95740f819622d584c43a91ccecc99b975"
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
