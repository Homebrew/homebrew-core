class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.47.3.tar.gz"
  sha256 "a46f55476a5f9a4a088270abb03c4f48e28d31d4be060e9511280ca5360e67e5"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc0c2b1e44620b7bb03d446635b94ecedf3717fbe672982622675c3ba0205d42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71762f6959087df30372bae9f687397398e4f4314cc604a1d26b044cb476bbc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08c4d7be9668093fba469023fac8164e88ad19c5742e8c5b6673e7704bf493b7"
    sha256 cellar: :any_skip_relocation, ventura:        "53efe2edbc9faa626264b43549db0b545fcc117d72e70da169d9125dc2fa3d40"
    sha256 cellar: :any_skip_relocation, monterey:       "cf9eeb08050ef84d3f0e6d030b02589ff267b132c3e23b2ce8c633245da5e306"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cbdf1ea43f9de16e367e3ce6aa4433953f58c9862fe1025621feef00469e488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3d7a7950114ebddc3ffb65a91d312e7ec827e89c672547072ea629de72913c"
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
