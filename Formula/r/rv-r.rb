class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "629fa4851ccae57dbdea86be40049ca14a9e4f3b0062ca2ce8259371976afaeb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57634b457401e437e9826cfeb481b6ade029a34591fa374aa78914f39a8faa50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52966c9324c64ac0e227bfaa9a4ee4eca73ceefdc798b69aa44794bfc30c0975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5eb5d76c37a0fd1269a2659b4d21d2d3b15a3f5ea8d27df13b91fa2635a0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f1b774c9c1dc8e698acca391eaef20840db2ed75c10601792cafda04003b0f"
    sha256 cellar: :any,                 arm64_linux:   "a7719223ddded8c9dd9e6c4d059bf4fe6ba77849aa86f7835cf6f8c09ec15ea7"
    sha256 cellar: :any,                 x86_64_linux:  "a6707dfa15c2a2f877ded4ddd86dbc2c5938798e16eb554313c13dc0ebbe51ee"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
