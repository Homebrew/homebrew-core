class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.16.1.tar.gz"
  sha256 "f604c6e20a8ee651ba71d139f94c9d41989363ed7002cfb0f352e72f022d25a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6156939f9a7859568ae3c3464e78fa38dbc625d7e7b2d99b7dea4a6fe246dab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6156939f9a7859568ae3c3464e78fa38dbc625d7e7b2d99b7dea4a6fe246dab6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6156939f9a7859568ae3c3464e78fa38dbc625d7e7b2d99b7dea4a6fe246dab6"
    sha256 cellar: :any_skip_relocation, ventura:        "788f4869b25dfbe90d17437fb3cc4756e3a56135579630b100ac5de1b907f9bb"
    sha256 cellar: :any_skip_relocation, monterey:       "788f4869b25dfbe90d17437fb3cc4756e3a56135579630b100ac5de1b907f9bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "788f4869b25dfbe90d17437fb3cc4756e3a56135579630b100ac5de1b907f9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5215b008bb5a8bbe8ca18f9665a5a7c46e473d4f63e3f3c65a6be41acc23314"
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
