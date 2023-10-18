class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.85.2",
    revision: "8a72c175c76aaca2dbc451af00d79b43e1c28a60"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d9c11fe1bdb83d8c58c79e4b60a639799a251dfbce5472ddc21aafd7ba7161e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c461f52184c5cf102b2cacb65d6ade09ae261df664378612f060d773e706ef5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b8d2e040f043e8a982fad794902b672763367dd5be60c4a8034587e357c4a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6418e091cb194ea64406ba038068629e981b7e4727293d7393712f97418d3ea6"
    sha256 cellar: :any_skip_relocation, ventura:        "6ed1b2b181f4178f51e0a374b5d6267e6815107fe982dd195b83714955129997"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a672e530b5bdfbe17a1ff104cb9ad91eb1ed23f226c5db6587a238382047b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a1f3c9caf8efaf126514e210a65285a80c7d354ce123e3cfb36b4e20bf8e82"
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
