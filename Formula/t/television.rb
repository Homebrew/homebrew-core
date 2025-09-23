class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.13.3.tar.gz"
  sha256 "4d3f5475fd4040ac64abc08395f4c769ffd40c9071a9a560d8038b233277b0c6"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e62e615efc79b0ea86957369073b965456d85c6763a9c04793a68fce6232b97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46a9786c469f3104946cf5297eda933f27045c8ca452590048c7e95d5cad2c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7063dcf8cec1e2327fe4377ddcca8e154a80e9be3079c8498148cfd2fcd0e6a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "199216b737b901b42b4dea99e6e57b8fab1b5b4066efdb6fbd3c363004404f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "b74787791a17a5cf6f61c4cd2193d5b4abf7a1e5b7c263b77bc1d0efc4878d6b"
    sha256 cellar: :any_skip_relocation, ventura:       "013c75469725e782c465a7fb5548f89730c1c4f93a5c86ab0d3ceb044caebd8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b85d1fdb4ea69eb83042a552c82e4bab6aad68d3a7dd38ea35787c6c1a996315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76b4914a8d80ec1a09e3e6a525e6750bf7d56c9089084feaede007e52d778637"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "Cross-platform", output
  end
end
