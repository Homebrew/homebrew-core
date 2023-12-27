class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "409484a70d95ca1e7aa97b0b150453fc1780a85c08261770baa59ac888a60b30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a0bfdff834c5a4bb8ad1be088eb82684444387368a83191952b8b6c15609e68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9da124fa269bbede4b79cf944dffb898a42c896adc9cb50b6348ef918daca090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b7d2f1bebf2489e637f8f6aa5414395eb3e981beb3eb1709c8f21faa53b02b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac9f1f864ad583950c50aec76a9b949e1821af787c7ca9429f781040b7b827ed"
    sha256 cellar: :any_skip_relocation, ventura:        "53ec2d14338337856af6431637ce5348ad7fe868eb6ae5cb079ff9597ca27f92"
    sha256 cellar: :any_skip_relocation, monterey:       "ff29efa9f29b31420ab41dd771620499fcfe0b637b48da83a293a8abff3ac9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1a886710548ac44a8e953d3c4deba14a815204bd322af6689cd7c98c420ac0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
