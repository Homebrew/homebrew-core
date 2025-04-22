class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "5d17781f701059946f876e87f6e92a53e0315dc8e70ca7462cf08d581a0e8eb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8177c1d7b1642185aa240d58b90a3dc5a01391ce840efbf2b21472e944ff912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8177c1d7b1642185aa240d58b90a3dc5a01391ce840efbf2b21472e944ff912"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8177c1d7b1642185aa240d58b90a3dc5a01391ce840efbf2b21472e944ff912"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed013b6831b2fb0c9624ad01606151010d90349337079d24fcf7e02e1bb3122"
    sha256 cellar: :any_skip_relocation, ventura:       "aed013b6831b2fb0c9624ad01606151010d90349337079d24fcf7e02e1bb3122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f109b3c2f4e87e934850038e2dc20cdf4533befe75deb96b07ca2e14ee80910"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
