class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.2.tar.gz"
  sha256 "9d1a4c785f62f68effa362c39eab1e0802fd40402416e8938ea7a7d4088945d0"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69bc7401d9c023c863d8c87dc3e38b3793bd6206c60adea81b810a72e1a175b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c3daf4b0825f75b7c491ec2b4945bc6269cbde31dd9b477cbbca22ef60995a5"
    sha256 cellar: :any_skip_relocation, monterey:       "bfce8f467e7b6e98417c0bbbe36a7e72c11f9b215d374d1754ae99eca2e4cf8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d1084151db7080d895b58fc0025d4ec70af5134dd825b8e6a10e1066d15a65b"
    sha256 cellar: :any_skip_relocation, catalina:       "26d84e3a8b8841b5a74f70f6eca90d79946d44b3ea9401d0d673f33e5fa9f62c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b798e6c86f66ed581cd5656ccc6136070ec131419504ea9f94c8adda4d54ab46"
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
