class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.93.0.tar.gz"
  sha256 "f2fc94c439986577bc7081d4c2bd8ac52bf3cfff8dc6db9308353ab3d1f8cac0"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25e5eeb7440e7502c056c3a61a47b4474ef9a1872e96066be61592bfd87143ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cd817d61496ddd07b519acc4726aed6678d4e083dddd38d635bea23d99c91c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c36577a51a130dcc11be9e64e6e32dabb410401e5c503360af02929a1b2b00f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "371277e2a9db028cd7e8fc21bd05e9154c513bda6c0a0b03130b1817b2939e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d77193f5f09a182058427145c76e16cd11e7cfb864b39e2f07bd9ed43e255d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6c7469e14c462e086cccba45cdc5691f496d28976f50712e693431bb699fbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
