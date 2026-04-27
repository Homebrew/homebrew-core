class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "758c15a6139b764840d00eb9f4acf2b286fddd1a311132010ea9c071b901f2e9"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f419c59429dc17e096223496b7531a55f5dfc159939745a02e695b336adf5d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f71241fd0bc11f3f88b98d7fb31c0c4d021ea1cb663841479b776b3477a6d881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e47fc976f6f22b5f83a2182b408532d364af7f4972f59f3094060259029a549b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff863cedd00a815229a722e9711404dbba4bc259dfb487560dc61afd4051c39d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08b794e772b682c954f2a2ea9cc4a22f35e0f1cd5383f31f3b64d42c43dec1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dacbaf5efab53138ca61b2e6f2d343ab8fc13eb559b3171c825ca37f4f556be"
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
