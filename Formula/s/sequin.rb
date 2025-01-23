class Sequin < Formula
  desc "Human-readable ANSI sequences"
  homepage "https://github.com/charmbracelet/sequin"
  url "https://github.com/charmbracelet/sequin/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "545b43475cd217465dbf5e620fb7bc129fca532ef768a1b51cfc1f11d8e98d4b"
  license "MIT"
  head "https://github.com/charmbracelet/sequin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721fb54c509d2685911ed51bec6be168cd599fb7d47bdec6088aeb866bc8ca23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "721fb54c509d2685911ed51bec6be168cd599fb7d47bdec6088aeb866bc8ca23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "721fb54c509d2685911ed51bec6be168cd599fb7d47bdec6088aeb866bc8ca23"
    sha256 cellar: :any_skip_relocation, sonoma:        "912641ce05cdc0060093637fa38add03e2c0b761c2c393a79a44bbd6f7502624"
    sha256 cellar: :any_skip_relocation, ventura:       "912641ce05cdc0060093637fa38add03e2c0b761c2c393a79a44bbd6f7502624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef1e5733c5184e6c8f43fdcd94e785f64b612973ee1612b8a43e428a67a5282d"
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
