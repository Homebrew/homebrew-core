class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.07.14.1.tar.gz"
  sha256 "aff18ba7b7a62696d9d0ca2124ac0efd2b62d05b5abebfe27a1270ce5a9fd3d6"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fea6e1fdf62bc39531af899157aae6df84013ddbf103059d947df171e7a7ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fea6e1fdf62bc39531af899157aae6df84013ddbf103059d947df171e7a7ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fea6e1fdf62bc39531af899157aae6df84013ddbf103059d947df171e7a7ee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "63dfd8781180e8bae55a148034e44acba83627999c193510d4ff585b85c4a01c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f855863c042117b3c019d31076dc8d662754303342b7cbc01e95724b0ea4ddb3"
    sha256 cellar: :any,                 x86_64_linux:  "eddd3cd4c5b6c333cdc3fa4af3a97ba60b02171c82175f4da794eaf761fb1bd3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/scrutineer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrutineer version")

    output = shell_output("#{bin}/scrutineer -runtime brew 2>&1", 1)
    assert_match "runtime: must be \\\"docker\\\", \\\"podman\\\", or \\\"apple\\\"", output
  end
end
