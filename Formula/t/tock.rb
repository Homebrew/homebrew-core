class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "8503d4b41bb378c752ad03cbd6d0a9f58f3eb43c97df8db46db74004267d17c4"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd87da66d2f59c9abb1f534bebf98507661d4043e800d62ea4e17274a0f7d824"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dbd96440af2ceffc50a9f593f7ec5a796c553a8a346abe3fdb35391483ab094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18b00694b167f6ff96ab59d7f7dafd77338a28d104a7ae93d8df23653f9fac22"
    sha256 cellar: :any_skip_relocation, sonoma:        "3588d203f0c1a771b0beba7059c6c275fef701745f01684845cbfa28bf83bede"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d022955144604eeb11b4ca247161c0f5bc5a79b399a7c58c42f02cf50b4257ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acdf43b3b93bc643332128ff81a7cef6eb363ecf21b563865b6b936f077f843c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
