class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "323a13686db73424192b48e1865c3a527569db9c21156cb49e2f315d6f2e3fdd"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9536c5f80660c95a0fcbb4c60b4747fb59fb71e178048b6954d7bb8b66fde2e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d06ffa1f5ce9fb44e6d8725d56ace5b64d645303296a98b23859883d2c469c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30f19c2f8010474688da7384a27e7eeda898060d75a00125214818ba1702937d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "728b7bf95741de01de01ac35337e49044c38ed14e59531363d307245ac47b5ea"
    sha256 cellar: :any,                 x86_64_linux:      "2ef96ad680e73bea6d7ec7239944d88b461140c063ed5b2f4fe0624870159d11"
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
