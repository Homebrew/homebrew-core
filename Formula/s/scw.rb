class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.55.0.tar.gz"
  sha256 "7252603b7d9aba3aedc2b1d870dbe09b6cd4be1fa543e004a064e3dcf48c72b8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27bb7281014760605e5780047233bcc2654aef87cdaba4037eb0103aab7bba88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "590853d87ffa045f06bdb9e4964d1948ab5465715992fbb05c4bd43cef6eec59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a24e339cb910593b5c67b88c9c96e87ee0876e8cb551380787051a754cb28dfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b2d0f1ccd5effbd389be1452f111481ff5402cc4398b85fcad5d6cf81a669a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac9634d36decf963b142a2861db6160a3a39cdda504d1ba7195a1ae42c1dd2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c8f4ec5f0211b98ad368aea37b59af2c98373d3f1192e5deeb982f7678f557"
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
