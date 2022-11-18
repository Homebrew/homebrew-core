class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/v1.1.0.tar.gz"
  sha256 "3328f10c1e1aec8d6c46d22a202872addd83c6b4aec4f24e5548f3048e4a26c3"
  license "BSD-2-Clause"
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41b905e65535685a0a5767e2ed489fd521a6f39141b55bcebbe47d2b7cc1ac4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f48361ce44cae44b7b8dcf74c500a68f744424ba01ad8751f8feb03b8fc4fee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f9bae6017de090181d64b9e1dd8412d56530ef50d7ea7f0d8eaa1413e7a3b50"
    sha256 cellar: :any_skip_relocation, ventura:        "aa62e71126ac6d833a570eb4a498a5d04574ef6c31a284a7b7a0128b6e911cf0"
    sha256 cellar: :any_skip_relocation, monterey:       "2163fe8879bec9626851943ad524c8d3699e40dd37ad9d74e97c45a18160e98e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5338e015a21ded1b71ef17b2b8b1bef9b03facb658b19e0866f1b3b11d1889a"
    sha256 cellar: :any_skip_relocation, catalina:       "ee71be23a8d9615093ad9b0879e78e9b00f1505fb0097c1c0040358c642f9bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8193e721fbc7c73e0bde8589f9fbd25da07eaee0bd9bfa583f96b08583ae758c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"volta", "completions")
  end

  test do
    system bin/"volta", "install", "node@19.0.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")
  end
end
