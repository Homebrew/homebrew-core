class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e8441ebb382c0f16fd8066dcc5258108a44fdd0c7f32ce260a168025fd0f62ec"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed314bcd97767478fafeac88dc301d47585b24547396c6089175aa01e9fe0850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b83e3b8cee08465c539f1224bc981e82282754add0a3783754f718fd7fe684b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec0841914ec2f689c036d22467167a617d3d0ca396092c41caed0c8f361d757a"
    sha256 cellar: :any_skip_relocation, sonoma:        "74fef6507270d96e4572804421c0f75ed9dd36fe87b1b5ded77d0e94e11bcbc6"
    sha256 cellar: :any_skip_relocation, ventura:       "65e9ac1027e27fc0a8c3817566d337f7dc27606f610339e127711f5389508f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4ed4ac6cd8d79b53c613c3866a007af6a328a0233f19a91117165308c33adc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
