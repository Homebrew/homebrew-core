class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "2315f866a9bed03d3251e53dd4c46d99a74b9c6138ac1df141c5b9c4a0f4a350"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1da6f8fb77c144b4c34c29f5145db3ef2031fa2c7014010b59ad01392ecddb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e57d788a6dd2c3895c66a96f6c80cdc5165df5e9d8a6d1d4e4d29b45c3d7ebc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c4be2526197591b92204cd3eed9979d0351616b8aeb4d347cb7a2609c8a06a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b638c3060bf061f5c8a424ac1073fcdb37ce730e9c8699ac39be2b6fe5762db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a966c3c7b80eab480cad0bd3b5be79b6ad367ef76c53b49d6bb2e877f8f70a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1480e7aa3efd9f9a2d789951934b89b313eb273b8f01e55f0068d23ec1eb9d0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
