class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "5665236d08738cc81d4360478e51f409f7596117d94e9b7c399410c5bb2127e3"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a69efcd9ff7e1271afbb72a41539bdc6627f12e06bdea82104d5d6bcdb3af7cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a69efcd9ff7e1271afbb72a41539bdc6627f12e06bdea82104d5d6bcdb3af7cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a69efcd9ff7e1271afbb72a41539bdc6627f12e06bdea82104d5d6bcdb3af7cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d57dff855e73aef65cb55a1697bd5c879447bf048679194b2f03f90c6808453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39ada37e1e7fd7e8a3f6f2f644c2b5c7457670154a36968017bd56132eee97c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ada37e1e7fd7e8a3f6f2f644c2b5c7457670154a36968017bd56132eee97c5"
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
