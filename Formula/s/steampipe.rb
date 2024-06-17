class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "620f0be8a6a9b2e711fec083b9ed23521d142ac942a520aca6b4f6a728483f28"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68a6ed2d776b856dc056838310a6bc0c2ef7489540c75abf75bc07ca1011ef00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecf1943dc62ea096d739c2cb842e2bc197843540cb467eaec717b9182181d2bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4612d15202a00d30081fd6301b7c7b345e26e1ac3d8f45646c691b9642c2bf32"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb98ce036672dd03597f42dd645d85880d01c9c12f3fad5c60f98226ae914dc8"
    sha256 cellar: :any_skip_relocation, ventura:        "7e29ba3646824199b6044bb297d3d568996bc78bcd2fdd1b0871dac1970955b8"
    sha256 cellar: :any_skip_relocation, monterey:       "b085925baae0e623258f84ea67c95c999a4b1d05b065db87a3dbddcfd3b9c35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4095e0cb65e61327712fb350ffca401b19955fd501c1fb4d190583e8c7eb78b"
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
