class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.6.0.tar.gz"
  sha256 "29b3ef91e171c217c0e1e324e6b49ffcad6a3a867b4f9395ac92776a1f50f858"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c6670d7160a93361b1fe57e9a6d032012156bb20ad74076208c51f2997f8fcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aacb641297ab959941794b68fa225c6e953ad2c349be3a352eb2d8ea8e1d2d10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af629990efcf4e1e5eb9158481592ac2f9ae6ac63cb13efa1fd3218a8ca715bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ed61863d684c1d067841c2b322ee1bc27bbbf98073a6a2089a2e0421c370611"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf2476f5f4456b6f05af75ca749e63fa9185ffba6288f90f149915eab57f3a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9ea8bff201006cea5dd346d1b4594209c7fd7fc0ec21c61c5b9cf752cef511"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
