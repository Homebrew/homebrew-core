class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "da746179cf40b5c08f1affcc84cbb323dbf6c3e71b22517595c3e5858cfe1108"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    manifest_sha256 "9fe7c50261e994afa332379f6aeec1d6bfb09cb58196e0c51c1e629ba2718ebe"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1fe5bd6d7926fa6a97e60b2dcd45f75be965b68794117e18ea4abac74701a97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a0dc803476dba8e242ec8b0024feebce3072fbdaf0019c852d8032868361486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2ce3f25b7bdd96d28599294ac02d7a596200992c2ee73fddc810df5e7f1eea2"
    sha256 cellar: :any,                 arm64_linux:       "1a5b2c80febb46833c12bc12486b0c93bc260b388d3af8d1c58874f7a3a7a5aa"
    sha256 cellar: :any,                 x86_64_linux:      "dffe020739aab0b5cce9dcfce9cd664adf90fb86f98dab66d7c941a062f84c4b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rustywind-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustywind --version")

    (testpath/"test.html").write <<~HTML
      <div class="text-center bg-red-500 text-white p-4">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    system bin/"rustywind", "--write", "test.html"

    expected_content = <<~HTML
      <div class="bg-red-500 p-4 text-center text-white">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    assert_equal expected_content, (testpath/"test.html").read
  end
end
