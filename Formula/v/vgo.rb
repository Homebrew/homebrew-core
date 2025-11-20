class Vgo < Formula
  desc "Project scaffolder for Go, written in Go"
  homepage "https://github.com/vg006/vgo"
  url "https://github.com/vg006/vgo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a2fee499c91225f2abe1acdb8a640560cda6f4364f4b1aff04756d8ada6282d"
  license "MIT"
  head "https://github.com/vg006/vgo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "625060653e73c0e996276bc83f4f6dfc586c10739248ea167e296ef4d1212d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "625060653e73c0e996276bc83f4f6dfc586c10739248ea167e296ef4d1212d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "625060653e73c0e996276bc83f4f6dfc586c10739248ea167e296ef4d1212d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed465eb32ba71c56fbb1f2430e89f8db84230a825ea361a7332d622065be2ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9544aa949090a4777ed45e28cb84512c712899bb7d2f512e4629174e261a3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00919354e85aa7eabe2a62e05f80e9704ec285193c5caf5a5a752d26af38084f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vgo", "completion")
  end

  test do
    expected = if OS.mac?
      "Failed to build the vgo tool"
    else
      "┃ ✔ Built vgo\n┃ ✔ Installed vgo"
    end
    assert_match expected, shell_output("#{bin}/vgo build 2>&1")
  end
end
