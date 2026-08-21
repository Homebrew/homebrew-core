class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.08.11.1.tar.gz"
  sha256 "228f9499e4cccee3db44df1494673c504b1760f563574e44d1e660f4005dbfd8"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b4d632d67df3be1fe56ec3f63477eb15400c24365a8be97a9cfe82159a34dd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b4d632d67df3be1fe56ec3f63477eb15400c24365a8be97a9cfe82159a34dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b4d632d67df3be1fe56ec3f63477eb15400c24365a8be97a9cfe82159a34dd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b32ff9cbfa4f08fbc1c60facfbcddc434f1ba039c1c8666e43db5e42685a3a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f081f42f3de705a139057d433be14210c9f9e68463641c05528b8505a6b005c"
    sha256 cellar: :any,                 x86_64_linux:  "783833e8e26baf3998118cbc80be2141c978c9ff70703a794f8a87f2dc777e85"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
