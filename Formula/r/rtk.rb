class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "196bec9e9b438f0b8cd0198f68e05f072ccdfdec2c2655a3562d6ea357fa485b"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fb44a84a76b40e7cdc84c550962f1a544f8dbc11aa334cf53440fe880f24e79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef0240dd1c9050f6da258c0b56cd5a5ab0da8dae8464741c9f4ae5098534410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea3a23ed5f4c1b2b888ec6221048ae4ca7a33dc1341a79a8b1cef34c118f84a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c74255ab96f8f1e2dc4dedb57a68f8e5e1931111dfdec6ee378c7dcb07266fda"
    sha256 cellar: :any,                 arm64_linux:   "f7b4d89640bdb2838b2185ba7da0b73df8261346068041c5e786cbae2b4def64"
    sha256 cellar: :any,                 x86_64_linux:  "0eb66bc01f3bb6b8150b35200a1c207b81adb3387300a19117415a78568c363c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
