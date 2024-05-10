class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.75.1.tar.gz"
  sha256 "4bc6e371a3409485857cc0b04ab994f0a2e13faf0bd6bb93ae2110b9f06324de"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5b9a12e9f69530f5e3b547699600d91ac0155c12ddf590c4acb6af134877587"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ffaa39a5359d8218ab5bb293322545ebb7c7824141008f7f53d983209495bd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "371cf2e8af0b5a5367c30b4e316b7699a000acfd9d6fdfb8adbfbe5301be867a"
    sha256 cellar: :any_skip_relocation, sonoma:         "11c020dcbca5e320e65ad9c6c24de18b3766e0e6b41e1f12edbe5ba665616e6e"
    sha256 cellar: :any_skip_relocation, ventura:        "a437628cd05bfe61cc2d33a7b3b6de0de488652b6984b848955e67e0edcfe82b"
    sha256 cellar: :any_skip_relocation, monterey:       "d2b653e47c9be513ec73b9668d7ae3a4ab3f11d2e2398616712bff4cab71bb87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a95a19e506f5d5ea7c78a8c5fbf12abd67449a029e02c3d8b8ac7d387b6539"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
