class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.56.1.tar.gz"
  sha256 "d4c8224879f5aabaf7b5831eebc8564f19f54501f62eeeaf63ad027f38b65d72"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5b12a997f32bc022eb01f310b5cdfc397587e92b13616e7316bc0e16dfd7739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbababfac7acb453faeaf1b4c924ccd1f4de83788b645cfe80fcd604a5c6f185"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cd00f4f6efcb786535b698c58e937df7d1ce150909ae81b3dcc52fd02adb11c"
    sha256 cellar: :any_skip_relocation, sonoma:        "185ecbd56454b7ba204db8d962bc3def691386bc6e4bef36dfe64d566c78f676"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3daf0e66e90b4781fce30290a219e3076b0bba160bea09b560d33f3ad6bc2f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "875b3775fe4a7ed571a8f9874b907f2fef47984ae115a69ed7249521868c982d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
