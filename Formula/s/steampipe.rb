class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "59fa1f050feed5228f9e4b70098820bc0581f9e030e72a7d5798663b7ff95c0f"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33de35893b3cf08ce0de1320684c92f92e9c70a0bc4b08b8000895beea95db45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f4456b3600be361c02ed5ba03344d79171bd5cbf00c3574c93369d93afdc689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf9ec2b22db158d366c77df08a7a8bd8e183259f3cf0a40fbd94f46eda81e0f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9999c4d7fdef8e1c5d3d1fc25030d70ccfd06e9fcbe007d9e80f823aaffa23a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d27a6eec929dc775feb15813361f84b1d0efae9b5722418c5c88401b3ff5e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be61c2337f62c61aa61bb1657bdb9e363d4e76fa64b495cf0a464e631fbe5f5b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end
