class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "5142bc8572200191ed1698ee0678dcc87f97190ed435c44345aaa9ad6342b969"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb0b1efc95f9cbf5a8f9c56f3872fd99dcfb15c6f36559ffeede268db2337e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cb0b1efc95f9cbf5a8f9c56f3872fd99dcfb15c6f36559ffeede268db2337e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cb0b1efc95f9cbf5a8f9c56f3872fd99dcfb15c6f36559ffeede268db2337e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8f827d60c24b936ac5eeb51fe7ae12b07f93ee16709a5ebc3133dbef7bdb4ee"
    sha256 cellar: :any_skip_relocation, ventura:       "f8f827d60c24b936ac5eeb51fe7ae12b07f93ee16709a5ebc3133dbef7bdb4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1341aa04b4102c35a4d9005d420546971d7d95e1cb0e874920378e0274f5aaa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1341aa04b4102c35a4d9005d420546971d7d95e1cb0e874920378e0274f5aaa3"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
