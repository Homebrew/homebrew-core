class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.104.0.crate"
  sha256 "5e0c5c4a619d5dad936a28be374c8c197da8975054f6d50c860c66c8fdb7797c"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "877f20ff653695005852911ba72e6003c252faa3715cbe9725b64f972d8360d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85e57a7af6e7c92499b84ed138794f79b90f10e57bf3269afa1437835abf9cca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b85308cbadbb497307462cb3cda6b6ae258309d0a60aaaa40f24dec1bd9b134"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebc4930f9a1c2277c93a9d528ea811b5b9bc3dd53805d9acafdd9d1a26ce7012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f705c4caefa05e03a2eef89add8ad7dcf4cc91a413063dcaefb4b890fe0f3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52a4dae92d6d898db2a656af9e693f8b9cab7ef86c658350effce80a3d200089"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
