class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "f712acdb6071c7c83f6887fb4fab76e18986e499c2cf687088287c6d265f9530"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "043d0eb31ef9b225542dad44555eb712c13d5b0969f5bbfb3a1ab8858cb8b1d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65a5f99c913ac4ca9c2fcd9d99e164fee3ea5b3dcad86859f519ddca13c36eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d7a48bacca7f19f06fae2aed998f1c6f1ec7b2664b6defafa9534ab9d6cacb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3544c841f6f9cee5cc7693f7b9b815fc40bf8c94233ac24d45647539ba6d3710"
    sha256 cellar: :any,                 arm64_linux:   "8b3e19fb1f8c29633931d81acca6a2c9b009f6078941b16f47540a33a295b333"
    sha256 cellar: :any,                 x86_64_linux:  "ddb8b274cf5dc1fcd0545c81ce0fe2d63f1f1e1e057f7c8d69ecf59a63ade9a9"
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
      <div class="bg-red-500 p-4 text-center text-white">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    assert_equal expected_content, (testpath/"test.html").read
  end
end
