class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "e54683eae585c7d3e47054eba9ff9e1e2327cdb3b705df0f96a9e66a0781ec5f"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b83ea813dd68942f4769d44173d33eba006fbba0450bb64eded1b054a9449f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ce4763255e2632a40464adee002bb35bf37c04a6b5090e736669e264de4fea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d0e3def74eee7315d2aa90cc779ef9115f1a6195ab0e0519c6788d9ed88719a"
    sha256 cellar: :any_skip_relocation, sonoma:        "85727a8c34d572087640eb7ae96453e35179ea8f0bbece3b138fdd9ef8291c37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9867ff406d49e1f1d91abf8cb26979b2d7bb158c9d8f3b7a5f48a4b430ad1a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afdfab9e84a51ce17751198df9bdd410ee28fe2ee923dc50cbf1701b2b9fc696"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end
