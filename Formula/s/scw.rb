class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.21.0.tar.gz"
  sha256 "59a5d68d94f31fe1345f43adee3b5ddc79992d0a74028788abaf47cf88f5798b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c246039a15b4a3cd960b9856ef04ac4171aff6d5698b98194fb0c42547ec4cb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "855e95f14dda043211438bddeda02dfda2ab90d1ac6d023fc71865e60e41f090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ccc559b46a737d198838613f932a61e37696a6f433e40c932ed305cf509d233"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e466ef4477a4568339931a3ac91dc7bbcd520cee1d494120aee2c5ad08f1b0e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "29502b94c86c734e6587b5013ba651d86f68ad61402718f7817272dde0f645b8"
    sha256 cellar: :any_skip_relocation, ventura:        "0dbf008aeea0deb31cacba01dc960a6d85596fee3f82e8e2dd580d3bb97b401e"
    sha256 cellar: :any_skip_relocation, monterey:       "c3c24c927c03d533533d126aafb23de5a0ce4be0e3f3cc6f29675d8469a268b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "03e402e8feaec3070dac97da0b19de13fa1a0d9618080534876eeb36adf95ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7bae21be0d4ab93d72056fa1f034f09b2f72676d13c139f0ed6ff80b5cc74d2"
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
