class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "27c9f9662bd053cafa7e2b52ef86a1cd7aa81ef8838eb6bcee49c04383c55db7"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "995d8ff20b34caabf1f99a019b0e2429834ea1a194aa2196b20e2189c3fc003e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ed7f0c7e9c0c3cc88f9a9187a871966adc831a81f436a8be6afefff1e5afb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c16e4a5fd761aa992a0f43c716614fd4a7817278188673014d96f452a4c83fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3ac0dafa8de33c1f6383b4850472888967ec52b2ebb4f6c03f9f6c4b2fe3434"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9cf267da76fc8c57308583d9a14cec6da750611ce9473b60c745540c24af170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "653cf5c1e67d2be14e4f27b28ec584a523b336b7856ec36d7225dd70a899d54f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
