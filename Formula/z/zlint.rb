class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://zmap.io/"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "9fcb6ce1de638ad7a5dcb86b8d7453f7c731895c79957413dcf543c79e7dad65"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b5f5688d08b8418caaeab1c2bc47d0e20aaf2186dd33c21d4224672e32ac8c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b5f5688d08b8418caaeab1c2bc47d0e20aaf2186dd33c21d4224672e32ac8c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b5f5688d08b8418caaeab1c2bc47d0e20aaf2186dd33c21d4224672e32ac8c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "baaa0ed298ca2cfd61683622dc21b2e12633cd494cb7447024fb249304f41b04"
    sha256 cellar: :any,                 x86_64_linux:      "fc8baf090bc3e934cdb025d40611d7fa2ab72225a79f787efd17d540df538836"
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
