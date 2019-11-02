class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.29.0.tar.gz"
  sha256 "ca119d05c236900d8e99edc6ede52d77e8371b1ea5d85b597417a71cb567da3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "61c148156aa592cb33d4465b18ce81d2ca528c8cc524499e6ead8bb051cbc64c" => :catalina
    sha256 "34d9e8efd3a91ee82c9ff509b2abeb1d017c4ac8aa798705c86c7eb394458e3a" => :mojave
    sha256 "5e43e3bbd518846007f88539d2826344b84c5ab10d156bceb56207efa6fa1a5f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
