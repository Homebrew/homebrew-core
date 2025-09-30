class SlothCli < Formula
  desc "Prometheus SLO generator"
  homepage "https://sloth.dev/"
  url "https://github.com/slok/sloth/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "d542de089ed46181e1903a9d11c221bc4f24d27441b4f55318653f64726adfa4"
  license "Apache-2.0"
  head "https://github.com/slok/sloth.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dfe08bbc2892dbc368b9f7b4d9dbcf4726fd357eae1181ab51840b66bde183c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae96943b9b9a9edcb04e824a1a4df89ce423c62f6f31af46129a4bfd221aa7cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5291b1caef4f672715f6c31b82efde32956e4318d72439ba5640596e595365ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "376063402c9cac1589b7502331bde641368c14eec1968affed12e98233fb23c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d583190bf96ecf2c6d997b51382aa470e99411eeabc8b10b8d361bbed62f86c2"
    sha256 cellar: :any_skip_relocation, ventura:       "1ac69a22fc2117ddaef0294a4b7d27f07c4ef4357c921e9483412fb623707681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc25e9c595fa04de2379fc1df0cc05958e4d0d425ddce2ce8b7f4b9b77b5bb8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/slok/sloth/internal/info.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"sloth", ldflags:), "./cmd/sloth"

    pkgshare.install "examples"
  end

  test do
    test_file = pkgshare/"examples/getting-started.yml"

    output = shell_output("#{bin}/sloth validate -i #{test_file} 2>&1")
    assert_match "Validation succeeded", output

    output = shell_output("#{bin}/sloth generate -i #{test_file} 2>&1")
    assert_match "Plugins loaded", output

    assert_match version.to_s, shell_output("#{bin}/sloth version")
  end
end
