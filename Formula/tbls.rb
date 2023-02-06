class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "fdd56b014ce94a26753adb16f5ef4e3f8f7f3ce24b0b3febd9b1679318829bf1"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "729453d3b04faf29528bc133ee9b8b1b166bcb7044a753c4b52db50077fbe299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e43099e14c7efc30f77844fcad0e32816d5133d6805089b527013d5b6a4d6da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdb7eebc8c100a130385bcc951aecb703f8f3878c10ceec1514c0075ecb19248"
    sha256 cellar: :any_skip_relocation, ventura:        "c8ad7e1d10a1389b7b6a95c876587668bf72550ea7edb6ff8dee08096b2bd15e"
    sha256 cellar: :any_skip_relocation, monterey:       "0da5d42181b9336f4da6a8f52715fc9e53d3b1611fdf14dbbacc76ab497d4b79"
    sha256 cellar: :any_skip_relocation, big_sur:        "4247d628694291a3abbf6e093ec916e40e82153ae8b9dd1574c62229c0db881c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ef1ac3deb71ede5b58c4e6f9ee4925e2e39878ad5bfc281957db28dc2abb74"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.strftime("%FT%T#{time.utc? ? 'Z' : '%:z'}")}
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
