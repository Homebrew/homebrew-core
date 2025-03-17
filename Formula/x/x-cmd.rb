class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "7e60e2851d9eafd2474b17706fef9919a31eba5aacdfd79e8f4d488f477ca021"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    replace_path_in_file(prefix/"mod/x-cmd/lib/bin/x-cmd")
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  def replace_path_in_file(file)
    inreplace file, "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
