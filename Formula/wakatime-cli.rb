class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.49.0",
    revision: "4586476c8bfcbd628ec10faaac67b6f7178aab0d"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "267b6a1618b002afde1c3eea60f99615e31f39ef92fa0ae466464726fb45b562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78ea91473b0c67208035cd86369978ff7f99ac688850a8620d2b45659424c428"
    sha256 cellar: :any_skip_relocation, monterey:       "dad8dd651686f43f4895d05852ffb95226501bb834ad7c95b627b35341e43a5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "64eee8b8c75f7cbe80fd4025ea024abd930f4c57511b203d65c6b42c5bc9c38d"
    sha256 cellar: :any_skip_relocation, catalina:       "f74bef58dacf36930ec32e3792a4303d0d99acc8aca1f4f569f85dad1ac062c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebdb63e43d9e5858dc4620e816d5c727ebd3676fa8bc3093d9c114dd3fe54ff0"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
