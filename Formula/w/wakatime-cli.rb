class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.78.1",
    revision: "da7cddaaa3543d50da29af366cd7916d17154f62"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f1dec61d66b93058d2213516a12cba24b346b65b3da063fbf8752ee27fce7e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ea63b46a5c23ae425ce17c49227b1720f326c406f5e0724826e30523fa449f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77168d73cc37bd1bb405df5c78b3059c5ec5376ef92a255b1f2699ee5e4f8b4f"
    sha256 cellar: :any_skip_relocation, ventura:        "36b3da953572a2802bbb8e1bcd7db7d71e52f7c35399bc1cfdaed6a30c7c54f0"
    sha256 cellar: :any_skip_relocation, monterey:       "a6072d78f76104104ba53d06896dd68cdd454dce32194e910dec1aa55e6fabb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "143e86543f60dcf9c3b7cb4d0f5c19073b319e024699cd560f8054e7c79fb144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a26eb341506ee152c856dd54d775ab446f916ca2a7a3c3db9917f562ecb161"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
