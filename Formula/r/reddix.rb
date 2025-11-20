class Reddix < Formula
  desc "Reddit, refined for the terminal"
  homepage "https://github.com/ck-zhang/reddix"
  url "https://github.com/ck-zhang/reddix/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "0c1af2b263d3c47cc64acd9addc3ba7c44731f2bace4ee8ad5189eb2a510b9d9"
  license "MIT"
  head "https://github.com/ck-zhang/reddix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e36b6e3eb90ab065727639e5feeba9aaf128f2f5da15d632c1b7b8d45573ab38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16bd6f29709efb81b7d293068c5ec997472333c282ca862ff37c4b5b7bfdb3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73ce7d393984057e45d43ff5b4ca5dc5b088ac05e068a9bc91187e50f3b1aaa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b57caf96d429888047520fd3e0b80441a529abe9364e289ba84cf4a14db09f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c97c722f8c987c38f74b01830953dd3bbc60fbfad023fa5aab2a27c914d8a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b461c3efb5a1425a1b4961aac63e43141787a10a0be669204b9e1da26991f7ec"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reddix --version")

    # Fails in Linux CI with "No such device or address (os error 6)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"reddix", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Sign in to load comments", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
