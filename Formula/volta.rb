class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/v1.1.0.tar.gz"
  sha256 "3328f10c1e1aec8d6c46d22a202872addd83c6b4aec4f24e5548f3048e4a26c3"
  license "BSD-2-Clause"
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3dcfd6c65b371576ca8160e66ce951a025ae361f8fcfd8fa0bfa144421945cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4275cd296aab5456e9622d5059bf2da5f13d2a76cb38790542feb0b8b08d09d"
    sha256 cellar: :any_skip_relocation, monterey:       "f37c5126cdf7772300510b7f9024a12ce732ccc72a9de0473c1529fec2addbbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "97046fcb096d1855088dd079a83ff369b8e687f58e217170d6626d691cbcb7bb"
    sha256 cellar: :any_skip_relocation, catalina:       "66d958ce29dec5420fb8b9694c385a7e4db82feb19691564f1ffa2eb1ecff8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5aa47390ca45161d6416fd3df3c84662d6058c2bea8cc999a52ec715588f67"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"volta", "completions")
  end

  test do
    system bin/"volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
