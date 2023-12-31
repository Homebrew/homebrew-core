class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "2fb389135d359afda4798b05ab2babba67c56cbbfe74b7ce2756c647f847c7d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3ce699bce1dea87e6d067ddab65bdda474c042a275a02b8e10fee842a7d61a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd1d352a62bf62ad4f01854e6154170a863b15b2f7e02149c2bc34617c891aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8592e4b835a71e3a1be753fcdcc69866f035bab63d618d199635c7527793c9ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba9a23f34e4333aa5e866a0fb95ca26fe60668f16954a42331c2e174f2299694"
    sha256 cellar: :any_skip_relocation, ventura:        "2d9d9c94b02aad7220947ce4680583bfaed1fe6e37687107804496155eacdc3f"
    sha256 cellar: :any_skip_relocation, monterey:       "0ca1d2fbdc5fbcf2b0e73cb755dc4b139587be9bf44d277dfbe0db83cf06d924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d355fed5a0f1ce914ac0a7fec3fcd1bc46d6429a00ef13ef096f0f54c0cf2c"
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
