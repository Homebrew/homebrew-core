class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.20.0.tar.gz"
  sha256 "72210a8fd3c1126ab4f9a26aa2d91b4515c78ae0691c9a6660c6be262920a044"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b274de5c5f3c9cf97aa64a6375d05103ec241becee3e6cbd02fe9a9407bed551"
    sha256 cellar: :any_skip_relocation, big_sur:       "9815b17dd2796aa4040207fe40731d4a9e1fe19cd581175f18a160f6162bfff2"
    sha256 cellar: :any_skip_relocation, catalina:      "4474cdd9d0ba47b09a4fd4a837d0c5c00d451b1f96290ebefedcb1837f0dc947"
    sha256 cellar: :any_skip_relocation, mojave:        "96b38e3a0d220d9278aef074196f576964a9f62173f00cf5a6c9cbb138129dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b5bf5719ba782cf6409a4693b2c0450e4e32465184031ac9196d9c408cd9c73"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=fish")
    (fish_completion/"stern.fish").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
