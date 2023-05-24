class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.15.0.tar.gz"
  sha256 "a1dc0eab2ca00974a953af77c7d590addbf2b945323e841214bd5dda03206d5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81732dbca9a7e0a502adb434b770ef5f57d12f4daac2c5dcf1912f951a5f90b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81732dbca9a7e0a502adb434b770ef5f57d12f4daac2c5dcf1912f951a5f90b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81732dbca9a7e0a502adb434b770ef5f57d12f4daac2c5dcf1912f951a5f90b2"
    sha256 cellar: :any_skip_relocation, ventura:        "c3c066a283755128eddd1f52866ba22844c57084b49188ab6f5c4e3102c5a2a4"
    sha256 cellar: :any_skip_relocation, monterey:       "c3c066a283755128eddd1f52866ba22844c57084b49188ab6f5c4e3102c5a2a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3c066a283755128eddd1f52866ba22844c57084b49188ab6f5c4e3102c5a2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "937b1aeb14d0e496a3e27c5a49396a6e7c5c09d0ca2dfca642b816719f3b692d"
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
