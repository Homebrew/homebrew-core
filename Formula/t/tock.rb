class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "103cbb45e6ec31dc7cab1d405e22f0f996fd296ac1d8d53053a3a40b5fe00476"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ea4fa14be27932b2f90965d99865981a5d4d5c1dde1dc22be930a95efec741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "594816977fa33fa0f293b9452c2d01584c09636146e111c4e0ecdc1b62e8e218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fa226da949604b5d85552515f881f3fc6ef2accb769179397052d5d13187fc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6481b0c70b33c9a09806908f35c18a7c933921b15df61ff9a56db791600b4c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "458995628753f7e262e001853134268b2d5a31c86f03ffd8841e40b75c34c9b3"
    sha256 cellar: :any,                 x86_64_linux:  "3c97ff8695bac0581d418e43d0905d45b70960f5e9600dcb1ebe8d2239ba2785"
  end

  depends_on "go" => :build

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
