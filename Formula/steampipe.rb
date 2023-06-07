class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "b3e8acd27ab06eefcd35cd52dfd003e4a7e22ca86798f4ae28d8e2644096f19c"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "896c81270c8726cbe4db52c9c2bd933d677205e7ce6bce73aff20d42a2d5186e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b37592ad01f35bf5a1a9a82fef3ec930247eb1233dde9c4bef9e65c7948a50f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0751a3043bdf126e02e311424bda43eb203aabd9b1b836bab679da3438f9def3"
    sha256 cellar: :any_skip_relocation, ventura:        "cb3b9a743f41cb0a55e3e296b868001386e66384dac30235a419f4a376500d3d"
    sha256 cellar: :any_skip_relocation, monterey:       "7d57af988fd5395d19566a724db34c89793b482781b1d32572f3adcf7c3ae0a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "53ba0ea9a70814b1387cad51aa100bddbd609d6af151d217196db73a91947a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39182156cae7d35c7815825e1fab08637186495a0c7e69115c2fb7e5e05b5077"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
