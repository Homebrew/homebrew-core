class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.147.0.crate"
  sha256 "9f362a1d8274e23265057f9cd30a6ecf55b7bf49390f3927a65b84de81f9858b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7780f59457af1c7198fa124698098c740d05502da389c5e601d0fbedb689636"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c61805d70ade45e9457ab6a26e4161cf84ed1c031fc1d2bc0b56c81bbb444e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1ab02297d8acf6cbe3d7dce8ba419f2fa41b37421df2960d4545a079bd1858"
    sha256 cellar: :any_skip_relocation, sonoma:        "4da1571a0fe983a658376d7c592f7598635ee7402075e238809671d460f178d7"
    sha256 cellar: :any,                 arm64_linux:   "551077f69447e67eb1000b7cd8cd50138f35b3b894aa1afd291159ca98e0fbfd"
    sha256 cellar: :any,                 x86_64_linux:  "2aae90c2cae5904318a214ac3e35ce0f2704f2380a00f3af2b453aaa5ba5c973"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
