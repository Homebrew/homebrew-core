class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "d1b91cd1e52fce371a42c2a3c12ee2cf2b629205a23af8bdba8ed9d3814c83ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bfdc610dc3174197d3ee79d0360149813a56207ed755048a1cf507df99562ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f579df06750fca174a107d3044a594e45081506440b2171e4a598008784f4fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8622923052b7541c40a1bc928e13614d449cc4a36a0198a36ea5387dbeef2f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4faa67463da13e39b49f33bc0764135fff238f0da3e189b78520558f894be323"
    sha256 cellar: :any_skip_relocation, ventura:        "11318a3af771a304ffe72b189805dd613a04311b631f37a8d8585ec63e55723a"
    sha256 cellar: :any_skip_relocation, monterey:       "2f7eb434f9806e9779eec33433d4776f62ddc502c194a94503287f83e130a65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2b7a3af150e6238b0e7f052d64947e92daeeac323637f7bf16e66d1119a487c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
