class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.94.4.tar.gz"
  sha256 "31872de7a06aa5591e5dd3193e9168cb04761ea65949fd825ef129ef4367a612"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dbb2128886256deabc0aeafdb45143d0df44d2c271755d89011aa0586fb6014"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00945c9ad6090cf420e955daae1b2257d635482386b2c7f0129a334c53d435f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95fd07597bcb976399ab85ff54319297d37bb5d07bf327d521efd84f924100cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2b53a492471bf60d0b52ccb71f2c814e6da9106efc8f073a76aee983e574c02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75938368342042d933c453c703f179f40531164380ff6e4165c325495da8daf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65289c698a64ad297c565072412c726df34f44476eb45bfe3b3f6bd9dda2ea4f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
