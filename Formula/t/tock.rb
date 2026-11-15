class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "0d4183ac42302b48bc40e59ce0d7144ff0fad2492c1764385d87bd0ee539d82b"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "282ee6fe9c8669813419d8a9bb264fd5014eaeca78b5fc61065f7b28c2792913"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "645512ad2cd22f1ccccec3521a7d76cd4033437fd44d3d75a49ee0deb2dc7b9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09a0d4ebef38d1f7abafeed81835e21378d8ea3addfdfa15d9741ff00c132b5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b32bc18341d011b22c2d8460a38810edb54a1352d7c2fe2096a041f2783ca05"
    sha256 cellar: :any,                 x86_64_linux:      "11791bf4336e6751cad096bd13b31c9235c17a5451a064604a74add0717a9e90"
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
