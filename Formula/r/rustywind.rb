class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "50706558f411722631db2449f5f05463703ebeffdea41f6e5f28f383992d06cb"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f6e9a477a66a134a75d813ce06471c85f5bbc114d56bd8a554a9ac13fe11544"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0916337b8700bf4b9d26f8e9f8ddc03f1de5cdcfa532f412886aed8cf64303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78e164d7166d1f303792912c049a135b139e07a3a3559b603d0244c99eeaa1cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb0bb9e45a527f1789dbc9181642955d60b2d2d48a930f318b7cf1e9bb1df47d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7d1cce25f5053ab0f069c4cebf50f590eb4664be89545ffab5a9c72660240c6"
    sha256 cellar: :any_skip_relocation, ventura:       "072bd55cac02cc31f978923b7d9c90a63b5a9d4ddd314dcbbaa495319825411c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7b5399f8ded336f4fa1756c9a0d17a26bb52ee8b5da16bc06fcabdcb2e8f838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2421d6c93d562c17fd6f1704b3775b26e34e6b7f9aa98c21a20b138efdb63870"
  end

  depends_on "rust" => :build

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
      <div class="p-4 text-center text-white bg-red-500">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    assert_equal expected_content, (testpath/"test.html").read
  end
end
