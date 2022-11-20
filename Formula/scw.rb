class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.6.2.tar.gz"
  sha256 "6643aa899b9012b5128a05f4cef3a5926a656dd56041847b14f7568c92374ffc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10050688b7267c55a117b2b7d26d2bf44c244e6f161537b9bcd413d8961bf3ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3902b2ef9a47240844ae682d917eae2cdab3afc1527dedc1fa5ca2980946e8cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18a7b83ff74d53bd087d0f86d39d795ae58b1950675bf28330b1be74db01f8ee"
    sha256 cellar: :any_skip_relocation, ventura:        "deac401381375438722edbdb0f6295a99f99c900049aafa2da5fd75c07e19ec0"
    sha256 cellar: :any_skip_relocation, monterey:       "58e571e9d4dd1360297b585671fea111dc7858260c78d0750a8664c58a3da92d"
    sha256 cellar: :any_skip_relocation, big_sur:        "edd0ebbc4b5c10081cce83ff4b33892de9338548bb635f3ec5e8da87a550cd25"
    sha256 cellar: :any_skip_relocation, catalina:       "72358b8b353b5bbfd853313e9e639b0984a030bc18f33a05d62587adde4abe68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b803014aecfea36a8ac8318391c1d9b894fd6cd1177ab1f4e79f1c28e1cbc8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
