class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.14.0.tar.gz"
  sha256 "f166462dd2b0fb8227dfd1d15c4e718b0917a5d5bb33aeb609affa8e7ac41b4f"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ad7f54e3f5c49ba3c5eab05551f842e290b96e4676419c7acbab58d95aaa3568"
    sha256 cellar: :any_skip_relocation, big_sur:       "0225880bdaa1f3630b3fb831d475ebc482e3514d754443fe38af617b270045e9"
    sha256 cellar: :any_skip_relocation, catalina:      "73be86e5bc19770e69ee6da080e4f8d3958befcb5be8453959a00c32bf59ca47"
    sha256 cellar: :any_skip_relocation, mojave:        "206c253d4adb59390f4fa21d112b85839c0ef3a4b72672d9c440ffb4a08e1d44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/stern/stern/cmd.version=#{version}", *std_go_args

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
