class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.55.0.tar.gz"
  sha256 "54ee709973448d769d09b8057340511bef0f12ca6f822f875fdd8c053aed9b1d"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c70c4f2b8983e2c47b86d4e98b5aba81a85cb31c4dda173b6fc7e02e69dc3bb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "504300415034a33120af51f620be46feeadac7cc10ce4729fca608b3ae92e8e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38d7600457feb3b5cd74fc444063eadb36535f9bde291d64cc99fcdef36c391"
    sha256 cellar: :any_skip_relocation, sonoma:        "73920599a167219c9d9c31461fcde18bf63b6a93ac5beff3640f52ba3182aa9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8be4c8b5c7290b7722c45b410238823435bf79da8e03027583fbf5c1204a4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c1bfa619bf6368d4f8c9f5a8d2c3282d549ebe86c1e7b1b49386c47cbcf18b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
