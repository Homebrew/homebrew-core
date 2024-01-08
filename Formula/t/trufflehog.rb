class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.63.8.tar.gz"
  sha256 "61b8a9b2fe725f509c22d74121f1052be613f54a685f593acfa224c639b8ac9f"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f89fdacb047ad5dedcd53fa30aaac2eb986ddd25260e107b6b170063d1c729c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03149a9cc722108f9fe579e2da2fc0db70b8a45324e488dd418eea40508f3016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e82099584b45d301e7922708a954a8c9ad2d1b482085bfc543a606f8d7165ae5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a69342ada3a5c35808855a7dc4ae303898d152d454d576fb7d20349e2dc44237"
    sha256 cellar: :any_skip_relocation, ventura:        "bd8ea8d87cd488157392c8798938d7f83fba1557193fc62931e04c4a4767dba7"
    sha256 cellar: :any_skip_relocation, monterey:       "f82929faec963e7455422c4594a38177d25ff12d41b64a9ce9285421af479574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866bf7778a5dd4ec990e34bd774943bd1991997b5f826ab3bd1bbaaf9818354e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
