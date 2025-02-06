class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "cf1959ee6742b98aa9dedddbb3dbf5783892f48e98087746cb3bafd7b53b0456"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e08f048d60ea3f04fe3203a3d78835949eb083be729cb3097dd2508785a1e815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d268749ee2926369e9d476fba89160c04472fed218ee7e5806e57269a736370"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44b5d8e91a1376649d9ad22d241c274ee5754aec240756f5cfd7a73d79f40b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a7b43790ed407d2f4cefd9c12324f04185a6e762857544a717eaadd0df9e358"
    sha256 cellar: :any_skip_relocation, ventura:       "38c0245f0f9c92cca481a3939eb1feb6431b8d83608661d91dc4008345c78f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "767f39d15df302f4e9ec646ed656cfae6422af6aad4a18a272fa0e4f669a02fd"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath/"hello.rye", :exist?
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
