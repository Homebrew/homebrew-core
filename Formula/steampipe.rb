class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "270118eade1cb2b27de16fb25fac20412ba262813b24b407baf9e1f8f1b01a44"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d21f91f07dbf21cb7b10e87d6e03c604f1544cbcefca13bd6a3a4648b7f4e26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9158fc49c8d52e2fcfdb53471c08cea5859ff07a05d2132b46bc42cd3be18db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "101213ad46a52f11fca3ccb9beade6ec0e6d38e7aa03cc0d33ceca5c9f664f79"
    sha256 cellar: :any_skip_relocation, ventura:        "782ef1e710a42957883c25f5efb08d6c4986bf775f000ee00a088d9a910248e8"
    sha256 cellar: :any_skip_relocation, monterey:       "ab933f424f0bbe0644c6cd024062d58af920b7c42a8a20daf5649b99542b1ebe"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce820dabe39bbd93747bcc589a8edcf99424a9d178c9637af7d22c147a95a0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e43e5c66fc0ddcb896ee44f8b1082fd771ee96e7d816687aed8e754dba0afb4e"
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
