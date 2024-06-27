class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "9f417ff6946921d6eab1094f54ac7dbabe527cbf8ba3a64a73174d5f6f399a58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef784f3a9492789046bf3d68d397c8cea6b7591a86afbbdb92e87a897f30c062"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9777832fb484cf865dd78fc50043a9e91ebf6c5d6d81db8a98be0ee4e3fdf69e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f51bb407376bc4465cdaf37d04802c9750cec9141193f260e98923fd3056e171"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bd57346b312c45c60c4f13834a5a09ae8a6dd77f7a13e9095ca8723cf471e50"
    sha256 cellar: :any_skip_relocation, ventura:        "4043a240b8579ae188920b22f4b306b6faf2cf0927159a1bf23034a818e187a8"
    sha256 cellar: :any_skip_relocation, monterey:       "94c57baf7a42b821a7532e456342511b8c8ded574f542b1ce6cce1989d962093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5dbfcb2d8f08b094527567c7d6ea8965fe3301d8ae546d6c7ab3f31a5f860a2"
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
