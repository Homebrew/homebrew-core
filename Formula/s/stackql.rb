class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql/archive/refs/tags/v0.5.635.tar.gz"
  sha256 "15dcf103b32058c38dbf5d5ff5d8097a4f67d1168e001c259c62b3feb6e03506"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1318fd9ce8b754eb0a254175307573297fd46bfdf9a1ee8ce75c3af2c372f38c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64578260b9c5a30f734a51334f70a57a896a7cd6ce5de10add6c90844559919d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7583a70cde87604067080c22088d6985768a766f9403e3f4a981264ebf89d887"
    sha256 cellar: :any_skip_relocation, sonoma:         "b283f3c7f82d9ae1db2da7d01aa85fb777f61065479a9df997b548ad92da361a"
    sha256 cellar: :any_skip_relocation, ventura:        "98651963f50789f942b00f99f8dadb8824a29572b8a8f9431f18e5d611765eca"
    sha256 cellar: :any_skip_relocation, monterey:       "5118138a45a7cb094ccb76cb1c93b3925655f3d29a8e73b7e4d3040e4ece98db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73f842fdd100ec1958e0a5b368647c3f227a3e6afd72fa3f0a1dd28e52e94dbe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{tap.user}
      -X github.com/stackql/stackql/internal/stackql/cmd.BuildDate=#{time.iso8601}
      -X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true
    ]

    system "go", "build", *std_go_args(ldflags:), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
