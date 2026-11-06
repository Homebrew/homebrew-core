class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "a299ec569b7f2dd7d3c2116f308a4bfbb6147b07ad0c05a88a46a408a16d7890"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99ea436346a5fe59dfcd15d4e48ca4698306bd7c00ad7efbc401ac88a4f5b1bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f612491ee1196474483128823eb6c53b6506c43d329636bbbedeb6290879a097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45ba3690a07c6e34f3e1eede98d35867b1f594d974b5d903cd35b44d57759f6a"
    sha256 cellar: :any,                 arm64_linux:       "3aeab5bc220bebdb4c6785a781de026bdbdd8a43e3854d31011eda81d377b290"
    sha256 cellar: :any,                 x86_64_linux:      "d21ad3ec99420f6a20260f143d0d5b3ac2a2362960393aa7bc8e3afbee2f4d40"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -- --f").chomp
  end
end
