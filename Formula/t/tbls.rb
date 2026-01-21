class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.92.3.tar.gz"
  sha256 "38a209650acd352eb4dddca9abcf294fe650e3fa4f08a959fd245dadcc813c5a"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f13568f9c69b3a609d51a5cffe60b59ad3b8a7b38bb791c2facf8ef46f317771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e7db926b8a963cdcdf00d08ab91d278888768e5d8f48a159a19165bdd6c95e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c0366b3a52025d35e588bb37102233ba05d9a0fabc0c5de37d8f78ca0a7faa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f713ecb4d443007888c6c58fbbbb5cf9ef2a003ca548e982750865ea87952d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eecd9b4ddc242dd66ab341a82329bc378ae8e6b66916744c519813cb4a489fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023533e647973983b49854c6a167b645722495117fa4cd64e59b06ad83f62fb2"
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
