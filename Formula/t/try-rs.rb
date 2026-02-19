class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0dd0f18a002d59f110559a65761c197ba8a47db3900a43884b11d55356a941ca"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8607a61ae3c6c20f49131c59c608ec9aef124606fb8656ca4e63ccdcd12b033e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe4abc927ce499a174291ea99836545f039aa5adf7079c4b8a131421f8d1e6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98c17df7843f3dc40ffa073b81d2dcb799aaf97355cbe3397a86681ad6307258"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4cdc957d55f54b040462ab3f3c311bc1eff36657559a559c5f222792e779803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd4921e0024c4d2b23c909d6e0373b4779049d3493894562fd75fec62b5bb75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73cd7bdd58088f0eaefede29897c1511d31078ff490088c7887173d05437565c"
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
