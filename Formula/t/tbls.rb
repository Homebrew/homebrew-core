class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.78.0.tar.gz"
  sha256 "e0854510dca4ca2364834a48e70e3fcb6ccaf7eb7b52df273a0a3fdaab17f088"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f444f0ca8fdcaa47b44563616311d0200affe1a2c518505416ed8588c29bd58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f320f357ba274847665ede81ce706e2a23830fe21e902ee1f07e6092701395f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24e1de201a655b06e5a27c1ad56ac9291bac4dd340bc01fdebe7b56fb4355742"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdc32d617bf78ce86664a72c089a08a0cc5b9a4295f69d3a07d970c4bda49c96"
    sha256 cellar: :any_skip_relocation, ventura:       "b3771995d95cbb6fc1f1dc2af7d33110dbea06d14ec1b3563f798aab3e1eb4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dea8474ac9ed2cc0a801fda6312b0c230a1ba8e7b10140e54560150aacde7cd"
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

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
