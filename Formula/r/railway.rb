class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.37.2.tar.gz"
  sha256 "5a4ee9477774d26d30dca43bd7fdb91cb41ef7ed3d473315497460dc07b130ac"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c34bff92e7f64681cfbf0fdddab799be3a94dde06889b536b18f083e77fc63b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216a9f6700680b7d8a56e4fae21c223f6ad2d793207f937acc995c6757c56852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0741911994358cd86f19195e1152a83f3a00861327f38ce15ba2a27248e780d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fb789e6c56c9295de0ea9833ce96ed77fb4d385486aff43bd6a91efa4b86211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca9b174e76b089fc58137165c34d0f427671a6a895b6f077102ee1e88741e542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b959bbef0d64021c2394fc3b3cf559a020c2e0cd821b24c6d4b79b008bbab9"
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
