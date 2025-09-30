class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "75ebac469ce88bc8e5b841be8749aa8abd6a54d3fb6de4d7a5dfc3076f7fbadf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43684a7e01fea5b6aa0c83f1c130748a53f6267a56e1fb5dd609667c4cb03e9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3868939904bd4eb1c9614f352014100df40a550af4b6282eea021a859c94abdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fb0a47fdd1bb4a29c54d910b50d8eafd9438ebceceff23096ebc10d18b8b0bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdf5b8749277adea716fd96619a59a553fa3855f6b71ced9429e24cb9fb0716a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8257fc9a12e4d996330227e5386b759968fca2ac71a5875660857b40df206b37"
    sha256 cellar: :any_skip_relocation, ventura:       "e4c6c550430258ca05f694e6970734c6315321e4077ad9bab7d5d6b5c5449376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f31481fb06fc3a815dfa42b43ef02d3c08d5c9483310bc00f8e142870e3d48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ea98ca60b01fdb0031b0d2b8defa4be64ea0b96050ac0200fdcd008612a8ab8"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion")
  end

  test do
    output = shell_output("#{bin}/tkn pipelinerun describe homebrew-formula 2>&1", 1)
    assert_match "Error: Couldn't get kubeConfiguration namespace", output
  end
end
