class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.1.crate"
  sha256 "abac7d5eb31dceda32d5e1cb6644eb6273c8e9af7ff7ca1c8631d1d8a5c86fe9"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7ece5f7b460c28e1d2b9c797f43fbda3ba53c9d37cc316f8c4ee2848d8904e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d3c5d54b092f5b04fcbe1f117eec94c6cd0cc85c839a57c3e6444771a24ceb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee3cd7a666e741d7c7d96c1199b2cdb7705ed516b9ea7cf67412d4dc6408f662"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c57aed28b09e11f1149ecd586fdb73834fd8ab952b56799003ce865f317adb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f228af81d2e97de3cf049d70da1ae71952d01a1d51e5777cea7074f9676ca60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67332ce435e3efc373299ffed6d6ec69bc7128e09ff755a0ae6c3b29c2c23d8d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
