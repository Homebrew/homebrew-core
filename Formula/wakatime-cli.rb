class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.53.3",
    revision: "8ec65d603bc0770363d89c7962b6a7515c7dd239"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb757f00436e7f1fb54c0193bebe53253b4649c16cb5e112f7e6fe0411b52418"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c71a3f05af0142bab1f03525d70336f0fb19768f6b094de5d8fa4e7a325e8ea"
    sha256 cellar: :any_skip_relocation, monterey:       "41d95426354dc7c3fa159f4f456c83743662445260bbd53d8d344bd0f0cc30a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "efc58cea17bacd9505e97197235cbd42648f2fb9e8a2966eedbcd17c51c32e08"
    sha256 cellar: :any_skip_relocation, catalina:       "0a05e2bb9cfa95de380928c43f20296e8dc3fec59180fd9aaedceeccba520d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a0f883eef4129baa1d40800e1f86044b6834e92b94a81c7f86ffc8f26a7e7e6"
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
