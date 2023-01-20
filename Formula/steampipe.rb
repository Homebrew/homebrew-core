class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "e374dbe54800dda40ed97df18343e0f8d7b8cf7d001d4b5db705c96dc27802dd"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7362199d49be10634aeca36bbb62dfbeb711030fe1ae8b648b4560ed3b22a6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc8cc76ad99e308234f5b48d8384a6acb580818eec9844f254e924d9cab45e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "212359996d3ed906c5f942e7918967f609c60f0307ca469ab2a449b6d98c5c24"
    sha256 cellar: :any_skip_relocation, ventura:        "3c19cf3d6e808c184ce3a0543a250d414d4f1218687d70c74e8cb17a5fd63688"
    sha256 cellar: :any_skip_relocation, monterey:       "babce1f6ae593ed9bb561cc2daac9a20c9643428a1b1911136ed2de1fe773334"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8f4a9e9d39fb1938800784b258b46487ffb8e3a7ec78101798e12775b467a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f21503f5521d1c1d80239320a432191bccb47e57d8201f41fba71d71fd04f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "steampipe version #{version}", shell_output(bin/"steampipe --version")
  end
end
