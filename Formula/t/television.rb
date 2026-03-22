class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.15.4.tar.gz"
  sha256 "d399ca013475af49f51e0284c79039755d9d3b11425e0144e05d0740fc203cd3"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "746384162013f01735486ab31bd866db9b5a998b5abb045290e017121945abe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3551768a12763a92237021cf00c348cba791a7122f907071008a9780fef7cf63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d34c706dfb31950160c4c3eac4efb0feb954d76874cf07c860a19db46e835df3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aedb219f81de4a54c0769c4764191835bdd04d1f9f658b9c9b00e7f0b6c0a636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fc58964966d1b05e658ee05208ec6defd82a90be6308a38f48f4397cad1fb48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639cfd981554935ec408207ef54dc63b4be6ea9e806cd3d4401e53375b720562"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end
