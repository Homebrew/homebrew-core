class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.74.0.tar.gz"
  sha256 "238be8093c19cee3f09a4a40efeeff22fd456501241ae4b8f22e66a6f7107023"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8fb7b65a62d8a50960faa7fe420a88049c162849f568f44384ecf13a0c811e06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e95cbf10bb0ba2abd2ab67f3376489636a0b03cb81a7ade72d53109d0e572cb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "077dd4297ea8b9730065f51ef3b17e46c5b2c125d4d5201a98bc088d514c0085"
    sha256 cellar: :any,                 arm64_linux:       "eaca6e655c142d8a09b4c8fae68c83d9253e91fc1878a8ecb3538b0520eadfa4"
    sha256 cellar: :any,                 x86_64_linux:      "e1e4fa8fca336b32532d6617301675dc22215c9ed7d392095a85cf2128fb5c9f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
