class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.63.0.tar.gz"
  sha256 "c1738407ba6bf69e04454f27e394c965a7d41c1d482a6a676396729f8a466824"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e22ce0fdc7b6838503566a3c15aebf14a37a07b0c477ca358064334c7fd976b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f723a1d06ea8d9a60093cc73261616da54fe36a19cb522cc1125dc7dfa8004b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1f47b5be82b111dd562ec7b8fde04ce7504f535712ae0495166b44a559648b5"
    sha256 cellar: :any_skip_relocation, ventura:        "cbda19868a3c560a158f6b54b47ba4c229fcd7451e15c65e31424861a699b79c"
    sha256 cellar: :any_skip_relocation, monterey:       "0afd477c7bdc08df7ae91c81f76c6420738c6403c94fead4390b63a246b63ce9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd18a130c4241787801dc9448209717f5e4f520b33e9e1ac5da53d079763ffd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3999d92685917d8c976d28cf56274dbf8c1353e98200d53c8f5568802d38d1d1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
