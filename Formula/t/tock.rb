class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "92280cc623aa1d3a63b8eae7fe47003b813426b761cc28a3f5e1dcdd79245e74"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e09349c7b22bbc43c6635278d5a1489fcfb49ccd4b34c99f4db250d03b96c222"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "985fb2a7ab53c4ef495dfb451cc9d2ea3522d0e42fad3b4ced986f4d779276b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "692ff935aa4cf57319fe616a6f47d4f35ab396f898f6f3dd2720b2939fb8c606"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1962e655ababccd6136d7502404e8030f4766a001014f63da3cb70f14af7e66"
    sha256 cellar: :any,                 x86_64_linux:      "426fa12e807720168132a01c8a0b1678ee8270cb6a4e0704b39ed152fbc70b93"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kriuchkov/tock/internal/app/commands.version=#{version}
      -X github.com/kriuchkov/tock/internal/app/commands.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/app/commands.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
