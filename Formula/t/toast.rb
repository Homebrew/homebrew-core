class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/refs/tags/v0.47.6.tar.gz"
  sha256 "6cda205ec551232106a05a94b6a71d9eb90e4d3bf1541e629062c65257aa3e6a"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "32d64e56a321339f6c83f3df40c5078da1b9327bdda1db3c96a1f0d59fb2cb27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1dad05bd1a76d6196771c60a29cc3c2256daa2aefd8d0876f24456e5d53a920"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7fa6a46b5891777ee8e5b5bb1b89aaf35a5cdad3f21baeea98e80f7aa699a1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58486cde44a6b9b49599967271149cff9530b74993ba06246fbbd98bb5c362e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6aa32d3bc36d78e0570fa12f27bc9f24feb78be4437660f5b1a8fddaf8316e52"
    sha256 cellar: :any_skip_relocation, ventura:        "6dc351063917baeec69ae6539b015e6fb3bd51b9af8454b8c9a5284cb386108f"
    sha256 cellar: :any_skip_relocation, monterey:       "eaff6a30895ff96444a5f3d05d3f12c2607529787a826318464eb26e04ae6186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c887eab22ace4352a4aac26714c2f2df9a3eea079f724f2748c3482c425bad3"
  end

  depends_on "rust" => :build

  conflicts_with "libgsm", because: "both install `toast` binaries"

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
