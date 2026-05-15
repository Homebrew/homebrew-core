class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "8f99012d2860587c5cbbc59c79c6f547eeabe3890575a3bec8eda25691df0ed9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd28a249b3c5841e904fe2b7513fe9e525a4ac3d8969f7574edff7c1db4d9bd8"
    sha256 cellar: :any,                 arm64_sequoia: "fbdb2b1f5256874628b5bb5d5f1a610c1a138b045b09c7d61d8ebdda32cfc1ac"
    sha256 cellar: :any,                 arm64_sonoma:  "51027f799e33595eaa7f6a3666f2346eafe127782e60bf3a26e40f6e7b4e9a2b"
    sha256 cellar: :any,                 sonoma:        "48e095f33810f19fd155f4304610f48f26bcdbbef871ddb2a36e572be8a90f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a751b80e2552d936e0e2e962da30e7834c8ee584f3b9c7d138fddf13407dd280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bfcd326d8bd1f84b6b366f8aed4a35917f67b615fe02f429a0a456e2a2f015f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/weave setup 2>&1")
    assert_match "weave", output.downcase
  end
end
