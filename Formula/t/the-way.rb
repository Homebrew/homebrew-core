class TheWay < Formula
  desc "Code snippets manager for your terminal"
  homepage "https://github.com/out-of-cheese-error/the-way"
  url "https://github.com/out-of-cheese-error/the-way/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "84e0610f6b74c886c6cfa92cbce5f1d4f4d12b6e504d379c11659ab9ef980e97"
  license "MIT"
  head "https://github.com/out-of-cheese-error/the-way.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e845a243d3985c6399c2284687ccce5b3fb6d222aac698f9be8f7cd3b32ee15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4494b131233473d0c65fbd5e3a47811f8f49e7759fc61a5274c33705d7091c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9882113a96595af349dce6faaaaaf6bd207460c137dd9e85e4b8991e8c09910"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68b6cf14740cad218421c8ed87ddf071d04f139e2e746ad8e241a1af23af9cf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ace9e79b695db8059908af5b68196e9da01251dfa8802c6ac592bb0fb4e4b0c"
    sha256 cellar: :any_skip_relocation, ventura:       "b4f03407e705be5dd0d40f7e5ae7388f172d1ee955dd667cc0d840e8e5d8240f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "845ef37713caf44d84308259c0e6c84be204d8dbab39ac2eeca81dc4061be11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e13db7053f848a032d23750e6facfbf5cb9738bfdb0025786f4308f407455994"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"the-way", "complete")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/the-way --version")

    output = shell_output("#{bin}/the-way config default")
    assert_match "db_dir = 'the_way_db'", output

    system bin/"the-way", "list"
  end
end
