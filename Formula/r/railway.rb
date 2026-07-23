class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.28.0.tar.gz"
  sha256 "4f68975aaa78f24591635edb1d0f30631c4d5ae117dc17668707c75b98acb193"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d926eeff4e6b2dd3d5c090ccb1cd597bfca70ef5dd93dc5ae14f3e51f4ed2be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d444400e5eccffc6e61b84c0225fed2340fc33ca46033b524325ec5a175368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd92c13893fecab504e1fa5a6a376b52bdba50714cc91cbef188d28d1f66edf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fea77ba0c4a10bcef85ec8881406a17cd59aa549d3b416d6fbc5772c12c137"
    sha256 cellar: :any,                 arm64_linux:   "09a72e139f9d218248d97a3e9aae94cb4f28bad2f98a1f1e58f80eec9634c03e"
    sha256 cellar: :any,                 x86_64_linux:  "c2c5546f941553bf9d984a17f03240bac140dc0fe550a2db922ba2ed4fc81e0a"
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
