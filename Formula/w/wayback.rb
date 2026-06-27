class Wayback < Formula
  desc "Archiving tool integrated with various archival services"
  homepage "https://docs.wabarc.eu.org"
  url "https://github.com/wabarc/wayback/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "b65833d8aa5c19ab8971c0b97bd96bdda235a6e420259aabe0daa5adf098d972"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe100d437e6f95b6b155fa8dd323d29a4a301c6343480f4191cbd44a674bb564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0684a17257ce53249c7e55249bc6e66aeccb68958f5697cfd5434fb70efc63f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0684a17257ce53249c7e55249bc6e66aeccb68958f5697cfd5434fb70efc63f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0684a17257ce53249c7e55249bc6e66aeccb68958f5697cfd5434fb70efc63f"
    sha256 cellar: :any_skip_relocation, sonoma:        "774972e3cf80db6e0a99bb29997108faa51cab0a713874425cbeb9b30756c41c"
    sha256 cellar: :any_skip_relocation, ventura:       "774972e3cf80db6e0a99bb29997108faa51cab0a713874425cbeb9b30756c41c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "461f5975a3cd35c91ef71f73115fb5d08f3b392c2a33d88aa882cefb651f41cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe1fcf1dcb7230f7399e58a45cc4e5e4e80c5dccca06d40469d2d23a4b772e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/wabarc/wayback/version.Version=#{version}
      -X github.com/wabarc/wayback/version.Commit=#{tap.user}
      -X github.com/wabarc/wayback/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wayback"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wayback --version")

    output = shell_output("#{bin}/wayback --ia https://brew.sh 2>&1")
    assert_match(%r{https://web\.archive\.org/web/\d{14}/https://brew\.sh/}, output)
  end
end
