class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.0.5",
      revision: "a3efe9d0916dd853ef29e81a97730cec1149ef73"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5a573a87bbe90fdf10e349380b65be965716b04dd44d110432b97c148546de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a62dbfef499d47e54a85825d105d62244e44c81641e1ece15a70eac3ea7dbb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c0fbcb49d785db009b132f10e1e933c7606edaf46fc9eed53e7c9f235f58f3d"
    sha256 cellar: :any_skip_relocation, ventura:        "15e20a3251af8604a8627aaeadf8a0bfe0709c5b37afbd123a1940dd2caaf8ad"
    sha256 cellar: :any_skip_relocation, monterey:       "d8f720533099d4ccf76e66523d1fb84a2eff40ae222e44111047a8b134dac632"
    sha256 cellar: :any_skip_relocation, big_sur:        "53aa216e1eaa03d2e9f2266745596b30d22df5e6dcf499c75783b5d87ba19303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6615b786e04648135c930eb0a97681c51569f0fccd952a45cdcf4ceefae82e2"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
