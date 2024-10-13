class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/4.0.0.tar.gz"
  sha256 "f13ab53eb3bd59733d3fe53a6f03dd42be3801eef7456155f520139036ffb865"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc0f5319f4a545ebe6e44c215cea5429977c59b15a713af8a0a1f88b0e8d6b8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f38a6c0490868ed638fb1adc1a58af504a357ae2c3d9f942fdac537457d813"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe92869a22866f07cdbb43f7fa6f8ed00e1c761c1984a2d747c07838ba75c68d"
    sha256 cellar: :any_skip_relocation, sonoma:        "adc970b3a392071b76afd3181d018b879c7bb5cba8031b6c9310fdbbeb79bc36"
    sha256 cellar: :any_skip_relocation, ventura:       "bc73db9b555ffea1603aaf4048ec5b1c216e1563502d2533b04f242f002532c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbbf542e120a9accf74c4c1972c8a11738e13efa0dc41ac19ed2ffbbc2dce291"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tspin", "--hidden-generate-shell-completions")
    man1.install "man/tspin.1"
  end

  test do
    output = shell_output("#{bin}/tspin --start-at-end 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/tspin --version")
  end
end
