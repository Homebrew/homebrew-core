class Zlint < Formula
  desc "X.509 Certificate Linter focused on Web PKI standards and requirements"
  homepage "https://github.com/zmap/zlint"
  url "https://github.com/zmap/zlint.git",
      tag:      "v3.6.1",
      revision: "82d733e4dceb5e69296c9ac9dd4d1747182ebe26"
  license "Apache-2.0"
  head "https://github.com/zmap/zlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaf5ebe66b3df9301f786804eefac2cdcb680792db374ebef53f1173b969dd3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e7b30ad780272b5e1ec2f00857be2efbea43e75700fe49790df6eba41e62def"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d116b2aa51436799aa21393cd9193e96c772f76ade12ef9a91e1653c698d16"
    sha256 cellar: :any_skip_relocation, sonoma:         "f499c31162d8dde9d06115d83c3f671c23a5d63e6fd0a1e676635b327a9f2998"
    sha256 cellar: :any_skip_relocation, ventura:        "b21c1dc3bcf1ce7569e982ee040b2ebf61b1ef2fc5951a5026ea9395b6304cf8"
    sha256 cellar: :any_skip_relocation, monterey:       "67f2010bf5c4c96bbeb629088362325fba64ab2d5b1c83ea8f11d8e3d0535b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "569e89ae85816f374fb1c052f76cf4f421ef435c21900c653da6c5927974bd80"
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
