class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "c7946e08ecf04b0b993f905c3c4a6899d0c02697d46a6a8534386d48f9445049"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40a3b14b5ca21a565e49506514ab1797a85f0d8a41b23e8ecdec77f08826c2a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3717654b94f5af915b813b1577c347207cdbf39cb1f7a412d823bc20788e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d42625e6bc693fa8192bb72e01b5f0f98f3b3407bd79860276baabf76ca34209"
    sha256 cellar: :any_skip_relocation, ventura:        "970f6e0c5773c9368dab8d7f93d9a8a0471e1f7e5ad77de1688945b12a745b8e"
    sha256 cellar: :any_skip_relocation, monterey:       "8f60a14f45f2ce7541ee48295635546965155a4c5e2501c2e1ed3be010a33b1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "593cb2982d5dcacd959998d536e7f164919e9e14286d7563435a495140e3ac00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adc680c65b769aa605d32c95d33abbb28fdfbfaff213782e63fe283a558d8997"
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
