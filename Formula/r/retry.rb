class Retry < Formula
  desc "Repeat a command until the command succeeds"
  homepage "https://github.com/minfrin/retry"
  url "https://github.com/minfrin/retry/releases/download/retry-1.0.7/retry-1.0.7.tar.bz2"
  sha256 "eb96b60244e09f407db9eb32cb9ad52361aaef4d19ca84817a6f88f577b60d6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da33a5e97f32fc809d45071ccf84d230b9647c14092eb7ce36b415df2b8b8c34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60acf30cd8124a07ca056a042cc970d73801333d61358e57a63c6b04d2fdc896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c52292ebe19072bb8aa91d19d49e5741d17839166b309c37fe130e22c7f545bc"
    sha256 cellar: :any,                 arm64_linux:       "6b45ef0a3bbb613e1268d4305586dff4dafbf65b8e392651c43ca2ef26cc192c"
    sha256 cellar: :any,                 x86_64_linux:      "eb370252234a39ee8886942351dc1a1193d7dd0eb272bd1ffd2d223d5d7a39e5"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"retry.sh").write <<~SH
      attempt=0
      if [ -f attempts ]; then
        read -r attempt < attempts
      fi
      attempt=$((attempt + 1))
      echo "$attempt" > attempts
      [ "$attempt" -eq 3 ] || exit 1
      echo success
    SH

    assert_equal "success\n", shell_output("#{bin}/retry --quiet --delay 0 --times 3 -- sh retry.sh")
    assert_equal "3\n", (testpath/"attempts").read

    (testpath/"attempts").unlink
    shell_output("#{bin}/retry --quiet --delay 0 --times 2 -- sh retry.sh", 1)
    assert_equal "2\n", (testpath/"attempts").read
  end
end
