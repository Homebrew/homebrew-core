class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.24.tar.gz"
  sha256 "7f5ca83cbddee992aaac340d26c7a5d9511d59d61a7eec923421b4c5ef1604fd"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbb9a01c97caa3ff626292e28a0249d1915adad98c3b5d42abb3adac4aefada5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e72c37a87f26f6e86dbb540b49bf0ea946c3deb96930e24efe5767357d5aa70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b072d4e217b6eeed5fd2a7f4fcbcecb756f66df6fa9acba747d6e9f9a6179f22"
    sha256 cellar: :any_skip_relocation, sonoma:         "33cd86c89dd516006dd13e1c0743319977ee62773ed108a9014d1723998d6efd"
    sha256 cellar: :any_skip_relocation, ventura:        "07b557297e8a7e0607275f3eaa1f19e4e03508ffbe608599b0a96017134702ef"
    sha256 cellar: :any_skip_relocation, monterey:       "5957b701cbf4138e334d1eb99873b7be20fdaac857f2499366051f2d15082f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9d0b0ba6febfbffc785476f734756161130662c2ba5ae0dde5b7e97cad0048b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
