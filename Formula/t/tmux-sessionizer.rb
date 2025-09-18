class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c3205764f70c8e7f94a1b32eccbc22e402cd9ab28c54d06b405073cae185bdd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31eba54816ac3d642e85c0c3ccc08c1738edea0278a8706423ab6acda7dc4315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20971b1673ee2cfa08f990642538eadb168ef54dce98400ff72cd1696c4ba283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91922de190efa1c9899f4e2479f8b4ad089b7d599b77bb1d06325b330d9b9fb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80aa9e9af59eddeba40896b474cd216e8fcb84556e8439bde6946c3c8d35a881"
    sha256 cellar: :any_skip_relocation, sonoma:        "d419591132c0593b5a0404be795a04464026f4ceb98c4f3ff011ec5e8913409e"
    sha256 cellar: :any_skip_relocation, ventura:       "807e3f2c36d3c0535d8f70ac197c777a112fcaa43c8baa21599c4508611086d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc042dfb028a16bbf7c7c5d56d8e1a66be403debdcc52805b10d98c804192a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1267d366d4184bfd6620de0b6f7ed966c86b9a0a88761cf16e16c1f2132da3"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tms", shell_parameter_format: :clap)
  end

  test do
    assert_match "Configuration has been stored", shell_output("#{bin}/tms config -p /dev/null")
    assert_match version.to_s, shell_output("#{bin}/tms --version")
  end
end
