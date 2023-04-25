class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "ae3f4f5ca3f1ac61c31445a40de118b7eae1d21aeca9dde3e66c7c6baea81251"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3f445e6390b1658575e25d1bedae953b8ccdabca8cf8731717b3c85709ab7f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e56550265bb476f042f5f7b02ca1f078bc734b904dc388bdc231f97f6a9c1f63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21ec2a71b7954cff4b548a7efc7105d693067315f89765d90fae77e8411c9971"
    sha256 cellar: :any_skip_relocation, ventura:        "e065f93cf2c24ad5e1cfa159a4dbfc4663b6725ca2b89d068f2197d985305c20"
    sha256 cellar: :any_skip_relocation, monterey:       "606ce71fa219812c0172d3fd6563cec0aa7d311e991ff0a9fc96d321b08e8577"
    sha256 cellar: :any_skip_relocation, big_sur:        "538c77200c707a673f440729560fa75bc0caf1c169ee5a2982573e4e144bb055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d134857e31045b52390ac53c4b8a2416327f6e941999850ffffe67737fa8cf6"
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
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
