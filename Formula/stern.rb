class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.20.0.tar.gz"
  sha256 "72210a8fd3c1126ab4f9a26aa2d91b4515c78ae0691c9a6660c6be262920a044"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ffc9d90c163e78ec739a24cc286a933fe7b8d151009d078d7359de9d8e55572"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c7c2e54fa26d5ef51384e69ca450132e39757d9db6094a80a08a222336632f9"
    sha256 cellar: :any_skip_relocation, catalina:      "d75b8b73ca3bf2eba1555f12f3029ad3958cc97e40e87404b905f6fd2a80b2ff"
    sha256 cellar: :any_skip_relocation, mojave:        "068322a9e42a26b2cd54ae49e88bfc8db7f5e06442f5ad9457b7955196cceb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095ae8f230ca97030a672bff36f26745ef3ad456a3cb1d4cf30b29d5592808ac"
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
