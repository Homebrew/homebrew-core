class Teaxyz < Formula
  desc "Unified package manager"
  homepage "https://tea.xyz"
  url "https://github.com/teaxyz/cli/releases/download/v0.13.11/tea-0.13.11.tar.xz"
  sha256 "9c12cf708adc120487a324712846d2b5257e0e46519ef6f2a3e9a0ee338f2b8f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "deno" => :build

  conflicts_with "tea", because: "both install `tea` binaries"

  def install
    system "deno", "compile",
      "--allow-read",
      "--allow-write",
      "--allow-net",
      "--allow-run",
      "--allow-env",
      "--unstable",
      "--import-map=import-map.json",
      "--output", bin/"tea",
      "src/app.ts"
  end

  def caveats
    'Most commands will fail until you run `tea --sync` at least once.'
  end

  test do
    (testpath/"hello.js").write <<~EOS
      const middle="llo, w"
      console.log(`he${middle}orld`);
    EOS

    system bin/"tea", "--sync"

    assert_equal "hello, world", shell_output("#{bin}/tea +nodejs.org node '#{testpath}/hello.js'").chomp
  end
end
