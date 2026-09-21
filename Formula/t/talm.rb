class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "6b302b2e005374274c2d9ddea01355d291e4a77e3def5009bab8416458047c63"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2e7a55cb595407a36e7ee7f4074d04330ea9419fc896e9fc414163893982290"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "456c207efcd939dc0b0b71b09c8fabae189daf2ebffd0286578d6d87555904c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb2847785b339d32db17c16c935ea2d15d9274dac8e699094079ffe1a3eeac5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4aa570dec00c83ecccb275355869f15b150386a8c3be5e7c27cd51830ff2877c"
    sha256 cellar: :any,                 x86_64_linux:      "27e291b5e74809cacca5224c3d436c9987d14edbeb3aae2269ab2d2adc3bdaea"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
