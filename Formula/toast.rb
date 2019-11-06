class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.29.0.tar.gz"
  sha256 "ca119d05c236900d8e99edc6ede52d77e8371b1ea5d85b597417a71cb567da3c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "27a91ad050b02fd4f8884e3a0c85691dafceaebf0783f5de62dc9e27c3e7e586" => :catalina
    sha256 "650470211d7e7bebfc167b56d659929f7856fa94c39b960c2e6e4fb2a150c9be" => :mojave
    sha256 "510be61a455f3098dab425d2fd3d6afdb8fb9d6c70f50d74749d34692e9c95e9" => :high_sierra
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
