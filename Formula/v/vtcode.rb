class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.105.5.crate"
  sha256 "2ca4dd496929ee96a06780a099f73ff2f7f0c752bfdb68610c232aaced1997f5"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8db0eb8248f769007ec41f12d8b8f8f55f51560e39c4cabb7569b693329b7d8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe35299675dee16ee405e54c7d17c31492d585bc6ca0e3bf0bf15739207f15ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c678b32eb598b0cb6e2ee248aef93671e00b8d6d6a1b99ea168bb7c4c21c1d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "21f7af7b65c14d56a9f6ab06da4f75f11874c7b19db2c648341d0f6bf81e1964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ab449e79f8c3b1b412273242fd0c1d9910dc22ba8581b36e3e387120ab7152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa3314bb55d2250e727dbae6a1ee5f203d02a795b0c21bb959ca0e10926b90d"
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
