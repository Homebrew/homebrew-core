class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.4.4.tar.gz"
  sha256 "14edec13c1b462574ff06dfe548294b76031049a75b4e709ea29411dacb19b4c"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94f002a462afadfcec856d768d7139d27f364ef9d58231bb369bba3fbfd9e4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94f002a462afadfcec856d768d7139d27f364ef9d58231bb369bba3fbfd9e4fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f002a462afadfcec856d768d7139d27f364ef9d58231bb369bba3fbfd9e4fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "df3317b260b170051692aec61658c9bca140f4f6ff32a3f675d00088849388ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af8013415385e8a9600b1212b0a3d04a414041cc749129a541cec2d8ba332ff9"
    sha256 cellar: :any,                 x86_64_linux:  "4542a5de1084a536541ba71ba3555ebcd3020620ab389ba39f51110b0cb08109"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
