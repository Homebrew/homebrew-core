class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "d787031659db7ba2ac0f12e26b924aad9776dc108d4350d35cb67d9c465b2b00"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02881fd850383349a8a6dd9c17f85420ebcb8f4cec7f85790fa5c79fc3ccf4f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02881fd850383349a8a6dd9c17f85420ebcb8f4cec7f85790fa5c79fc3ccf4f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02881fd850383349a8a6dd9c17f85420ebcb8f4cec7f85790fa5c79fc3ccf4f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2148f21540a7e8049d9dad5b967471e7cd023cbc61dc0524b941b459450c562"
    sha256 cellar: :any_skip_relocation, ventura:       "c2148f21540a7e8049d9dad5b967471e7cd023cbc61dc0524b941b459450c562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6ef4f5002003ffb0486a2d62fdeb2a8161e833d98b0b31144b1dd1cbb05196f"
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
