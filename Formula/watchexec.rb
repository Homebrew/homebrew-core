class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.16.1.tar.gz"
  sha256 "d8e8e5ef6c11f4a7512f4841eff8960558edb39f54a563e5dda8e1058ff057b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "837813c9ec3c686db579447ebf6f2e25f1dc71d5ae202470173faecc21af4ae7"
    sha256 cellar: :any_skip_relocation, big_sur:       "4aa7de3d0cbb0f97e0d0e268546332b9f589f01b0a88a2cd76f3dc7cf74dddc0"
    sha256 cellar: :any_skip_relocation, catalina:      "42a598079325979f82db7e64e63adbd09e972a8b1eecc9d9e17b0d99461cdd5f"
    sha256 cellar: :any_skip_relocation, mojave:        "fc45963c92d0895ea27ecb54fa5d76575e030ee03d7cf7f23eee76ea7765e483"
  end

  depends_on "rust" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end
