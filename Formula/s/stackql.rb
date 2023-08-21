class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
      tag:      "v0.5.403",
      revision: "6722406bda570f230ea605671a9da7d2798c581b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31e606af8ce5025df56053c88524a346734b9e6203f8693c6843d6a2ffa1abd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7872b560b6271c279e0e8280c5c95790c92a174cc6fefa6923ce69573b8fc9fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "427b7896fef9792b254dc9d0e676e40f36ff457e1a53211078216582f729208f"
    sha256 cellar: :any_skip_relocation, ventura:        "dc7a46a1fb36b270e97afdaeb693ce069756e9cdab79f8c6e5d0bc71eb44c6ba"
    sha256 cellar: :any_skip_relocation, monterey:       "d8de6111fb992eb2e2106006016a52e9c79cabd315fb7ff222a43281771da617"
    sha256 cellar: :any_skip_relocation, big_sur:        "495ea4330717be2fd71e3e80848218bf321efa77d72c00510f1fd08e09d27fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eab77ea1c82b83eb82a6ffb42907240f20c4ca6d1c15d7a0e94eabd5232940b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = [
      "-s",
      "-w",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=#{version.major}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=#{version.minor}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=#{version.patch}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{Utils.git_head}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{Utils.git_short_head}",
      "-X stackql/internal/stackql/planbuilder.PlanCacheEnabled=true",
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql v#{version}", shell_output("#{bin}/stackql --version")
    assert_includes shell_output("#{bin}/stackql exec 'show providers;'"), "name"
  end
end
