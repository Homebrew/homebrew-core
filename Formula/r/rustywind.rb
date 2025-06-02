class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "90559cb75c9b28bfafd04a1e800b482e374eadcfc21a6be1ed369651d066ac4d"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa6fc45b7eb5a94e38d0e14501733e4830ad1651d7fc1b4bb99540d4a79a06c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6c62e9eaf19501ad9da415b8188525c650dc1cdce403badb622b69abbf3953"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "440358b83270c570a29ac7ec98b95ea0f6a8635c0612644661d6d6c90efe4ae0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6875be6f7d2da731a802a1cab0080ec1f4fbdc0d9c647830363702ca43769fc"
    sha256 cellar: :any_skip_relocation, ventura:       "98ff021f7a53e32a4bf2eb01f6deface7b30d3bbbfc18848253a3e7e8039643d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b9daabcd8287bc970c38b2300894a05844ea64b5a403991e7472eb3c9002a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa846b03600f391088b6bcaeebb11b9e9bde7ce2eae48b84ce73a34295c5fa5"
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
