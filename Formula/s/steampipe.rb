class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "f577e9f97e4201366cc6753968e3fac8bb937fd04fc43bd2be4678f0fdb2c91d"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34ddc40a98231ba3256fc792d714b65f21716bef5886116693c03f6ba0af13ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9298d1de27ede36be68c52ec7acf7124816b362bc826642c49898121c0926be5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31703538afb74ba9f562f1965af954d624cabdb20eca112ab2430b6de04cd05d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0962405269125a2615103ee93b7dd88a36eec0a0c46c07699779ce6594f0fbb3"
    sha256 cellar: :any_skip_relocation, ventura:       "ef990f8bb96b81ad67ca4074b97b1643ea7cba5580636450f9f729a73258c639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03047a7eb7b0454e137b3bd4afcb1fc88b1116dc702f06124a7e2dbb60e699a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create sample workspace", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
