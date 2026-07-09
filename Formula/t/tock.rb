class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "436f536799abbd6d8b35a1bc33e3cd3a616126d2063f37d3a0e115470246a94a"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8704bf2409fa260cc1b27d52341706feae54729b229821376e7371ec832b16b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94ecee122c64308829360149f94b5e1f462e97fe96aef2e5131cba0a5ed27f78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20b05a4f2995c62eb2ea9b50cff204400d2ab434815568857d2f32be212595b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2ed9b9e1efe28072ede58e281756d9c44f5935bed00bae1736e630d46d52dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c4afca974615c7092073efa5d92f5980ceb02686724be7e0161e003474f7077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af28987d8382106d04d619cf15c1a5b37cbc1b322a0183a7d87fd9daf9474534"
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
