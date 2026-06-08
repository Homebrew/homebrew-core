class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://zmap.io/"
  url "https://github.com/zmap/zlint/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "90b501bafd7533fc0831643ddd6d595751f8d0a1403d0bf0201a2a18da712eb8"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dc0f61552d33bac3b5181bdb7d43a04e603bbc84e895fd474a513f730332ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dc0f61552d33bac3b5181bdb7d43a04e603bbc84e895fd474a513f730332ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dc0f61552d33bac3b5181bdb7d43a04e603bbc84e895fd474a513f730332ffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccaaef0a3d695c7c99f6359fb97ec6bafa91e728463ba086a864088d34ae67ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26bc9975cd6c4fcc5368fd69138aef01a885265a42c4770ed6328c1eb2cea779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a16d321aafcd9ae1aa26ba851c4caf7c74132aa271242e6e3c49ce56f7f322"
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
