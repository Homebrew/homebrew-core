class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.46.0.tar.gz"
  sha256 "292a6bd082edf8f7c8877b1641b814a5c57601b1105acff6a74050898052dce8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79b750938b6cf0a0ee753d4f25021143eaaf2192f2a1d197b6e60f7e4de50875"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04a8142b63538a639b68d80886bc06153a850629af6ab2f29c61fadcce03f5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29b46afb74c7893df3ff3fa2135c8a3ffd925e558f4cd7a7e649e53e5277f594"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaf89505c659cffd8bf0e90f9f1cf4352a7a91b4096551980ed81859e8c0606c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a90b48b63a2ee951be687c7c66db84feaef11f6d57476510c9b3fdd9dc7e523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "857e71db905ac00a95301f43f5625137d6bf9f9f07d6fdd848b0d6a0851dc628"
  end

  depends_on "rust" => :build

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
