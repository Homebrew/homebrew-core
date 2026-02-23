class Reef < Formula
  desc "Bash compatibility layer for fish shell"
  homepage "https://github.com/ZStud/reef"
  url "https://github.com/ZStud/reef/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "316607217c85ca173cf3e3ce8a8a64978421d1f813e922f243673d587530acdf"
  license "MIT"
  head "https://github.com/ZStud/reef.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build
  depends_on "fish"

  def install
    system "cargo", "install", *std_cargo_args

    # Fish functions
    (share/"fish/vendor_functions.d").install "fish/functions/export.fish"
    (share/"fish/vendor_functions.d").install "fish/functions/unset.fish"
    (share/"fish/vendor_functions.d").install "fish/functions/declare.fish"
    (share/"fish/vendor_functions.d").install "fish/functions/local.fish"
    (share/"fish/vendor_functions.d").install "fish/functions/readonly.fish"
    (share/"fish/vendor_functions.d").install "fish/functions/shopt.fish"
    (share/"fish/vendor_functions.d").install "fish/functions/fish_command_not_found.fish"

    # conf.d
    (share/"fish/vendor_conf.d").install "fish/conf.d/reef.fish"
  end

  test do
    assert_match "reef #{version}", shell_output("#{bin}/reef --version")
    system bin/"reef", "detect", "--", "export FOO=bar"
    assert_equal "set -gx FOO bar", shell_output("#{bin}/reef translate -- 'export FOO=bar'").strip
  end
end
