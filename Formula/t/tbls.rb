class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.78.1.tar.gz"
  sha256 "0a2685cec98ff43487fee3443acd179cddc7dadf1a47c08e6a6df38c9195c2b9"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e3e8c8f581c2a2846440e72941d218a3b21d1c4f3b58590d58065767f50f5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8318b16f76c745fb3787b241e22d64b8072c43c415dd5bc82b627d3e38b5dcd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7474bfe4fb6ea69cb69b083f5d6088ec134e6b03a690f9e70e1a2621f1435716"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8df6c562870b50e59bb06ec004c3e8fe40bce0608bc229d8ab827dfa2d2b40c"
    sha256 cellar: :any_skip_relocation, ventura:       "3734e770aafa025ebdc014846c3d7cd821352fd1490dcb4489a7a6e590297e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd5b13b1d1417666134669aef5ecb70925b34378e911abea215c4b2dc78d585"
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
