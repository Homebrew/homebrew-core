class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.9.4.tar.gz"
  sha256 "adf8bbf49b6bde407d9f50fec4267c706a328594657b1615f6f383379dee85d6"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed88e128bcad64dc10420c51d1c4ed2a9ee7ff88a1ac2f984c9c8821e703f155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edb231f5f84cfda84963d01a63085b46103a4c2f4f62e5a61c661a5960ec866d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "340d4920ccb7916a47bc1cef1466683436aa616b9d095adaa2046921601e0867"
    sha256 cellar: :any_skip_relocation, sonoma:        "881f0dab1a237e195f056cd395eca80a78b056fae0da74f83b9dd1ec4bc73e5b"
    sha256 cellar: :any_skip_relocation, ventura:       "736a349aec2f634b439cbb752623794891563d50e593eef0e57c5471e7a483ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de03c6d75ac411baf7cdf278be08074ea87e71e05d187167e67787730155a885"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
