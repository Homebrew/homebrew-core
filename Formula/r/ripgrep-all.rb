class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/refs/tags/v0.10.10.tar.gz"
  sha256 "17fadc7b73a51608d57f82b4a11f3edc0da87716cc4b302103eed9d4b9010fe5"
  license "AGPL-3.0-or-later"
  head "https://github.com/phiresky/ripgrep-all.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a9273f9063c28cf81ea8cc7c5149e587a68ee73ebe6a11ca8d5899ad97b05a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "098963fe5e660560264fa2bdf55a4e0689ecd0ef15f24a0a7819946e5f150619"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4358ce8b6f6c9904c3db18e3a20a8a02b222b74ba3ced112fbb303f34700119"
    sha256 cellar: :any_skip_relocation, sonoma:        "492ea96a51e34f1ecdba5c5da4c587324eb0c7e5959d4e493a663b528b5b885c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "039158fe4635df5c4b1596be7d62d4e0177a8c3caa09bd1ba5a9715c1e3dab75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "640b5394853bac77a1805e11518ab09d1623a8ff9dcacd161eabbacc4c46cd85"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zip" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
