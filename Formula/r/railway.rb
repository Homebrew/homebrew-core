class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "728174507cc3187e14eae0643c6d61422d6f0b1d4da45c60d03e257dd4a9ea77"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc6f68773ec3e4724a0021bf680b2ea19d4db0f56f79662ca3141d2e2747a39e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1eff54ed06fd29fa6159d18625d6b98e559f166217119ad45635a84ff6cdd91a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1061586d0677083a8ea6f725677494994af5e5f6b96d2639c7258930643b4adc"
    sha256 cellar: :any_skip_relocation, sonoma:         "41ad1eeaba885de694cd56de0d5499aab7cef8ee14d974650289d17959451324"
    sha256 cellar: :any_skip_relocation, ventura:        "3cf97a9b50a0ed8806f5afd1997731f8ff7acef6f5aa90aca1ec6e0130d6ded3"
    sha256 cellar: :any_skip_relocation, monterey:       "5d23766ea6b2eb21e34ace6336b37a1b0369c1037ed4f67306e9548d833a2661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1487502c809a99af87b3408a2e2cefc3a6656b3a62e0d01732e939f9f8a817c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
