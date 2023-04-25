class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.47.1.tar.gz"
  sha256 "3c3c3abc3185c83cf44c4c97423f3130bc739f6c080115107bfa2ab52772eca7"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e34e671e913bd31eaf5afc21e9aa1fe2bbc92f279626731265f72ba21fa26a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919368bc7229ff725bee82fe6b6679453441d68f5d22b9c13eeb303bbbdb81f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "697b0b155473278bbfca2f83d129e15378c5abd6efb71641d636b305450c10ac"
    sha256 cellar: :any_skip_relocation, ventura:        "2559b05cfec0831f8354a74beb86030b092327563b4d4acc33eae52bae00f47b"
    sha256 cellar: :any_skip_relocation, monterey:       "4a1ce4af07143e8d18ffb40218948e384aade0a0ec8f464c34ca7756f6535250"
    sha256 cellar: :any_skip_relocation, big_sur:        "95bcf63a0dbcbe475afa23d7098ed0019d41953ce8848ddd330548616019dc56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c600fd0b3bb6b8bd8f2f9fb5d509aeb3711738f2c7088d9cc365156e90ff75d4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
