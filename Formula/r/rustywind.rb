class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "63b8f81d94a05130c985157824d491ffb1454e8afc3bc927d23c3980900da75b"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    manifest_sha256 "7124323ac6c209172f0acb8d1fdb4dd20135c2ec3c140f3eaa5a57c6bc246161"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9350cf11668e322eb07eed38334de61af25e3a9073a4da800242ed6786995e25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8660673c4d39736869ff69a8b74d369287d67a2561620fb5cc6c773a5fa9d760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62b7a602f0804ce0c370528e5ded03e3adf68c6b95e18d1fa94b89bd9cde9372"
    sha256 cellar: :any,                 arm64_linux:       "da1f490ea40dd12ffab953ba3c464426084b277893725e0aec6ae5c4661ece81"
    sha256 cellar: :any,                 x86_64_linux:      "e8bc5e0a6aff3666bc503d60ea07e951ed0ce6056478f1daa352fc2022ddf503"
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
