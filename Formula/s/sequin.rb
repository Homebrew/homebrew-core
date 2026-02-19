class Sequin < Formula
  desc "Human-readable ANSI sequences"
  homepage "https://github.com/charmbracelet/sequin"
  url "https://github.com/charmbracelet/sequin/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "52f4d704a6e019df05dfc0ee3808fdf6c7d3245dcaa6262db8ca33c9de303da9"
  license "MIT"
  head "https://github.com/charmbracelet/sequin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0336aba7862907b4a7e88aaa601bd17d0231cf1eeb7eeec7e089668602a9eef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32652611883fd7d3c9a2cab5202df945420db404bb0058c07faab677c9276086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32652611883fd7d3c9a2cab5202df945420db404bb0058c07faab677c9276086"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32652611883fd7d3c9a2cab5202df945420db404bb0058c07faab677c9276086"
    sha256 cellar: :any_skip_relocation, sonoma:        "a91c3cf6c460ef367bbb99f11fcda31a8087d385a0e1ff44a4ad535e1d37e53e"
    sha256 cellar: :any_skip_relocation, ventura:       "a91c3cf6c460ef367bbb99f11fcda31a8087d385a0e1ff44a4ad535e1d37e53e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c063422095a5fc609fd1d3ea2ac9ee60b5ba2a3503c6ec57cbfd92f0e946d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f60d1afbcead268f9a378e723c2472fadd0e1f481c06c8630914796f42d1ef89"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sequin -v")

    assert_match "CSI m: Reset style", pipe_output(bin/"sequin", "\x1b[m")
  end
end
